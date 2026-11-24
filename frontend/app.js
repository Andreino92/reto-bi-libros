/* BiblioPrioriza · lógica del dashboard.
   Todo el cálculo analítico ocurre en el servidor (SQL sobre PostgreSQL); aquí solo se pide y se dibuja. */
"use strict";

const $ = (id) => document.getElementById(id);
const S = {
  meta: null, esc: "base", p: { me: 0, md: 0, k: 10 }, f: { cat: "", pmax: null, q: "", coinc: false },
  data: null, comp: null, sort: { key: "prioridad", dir: 1 }, req: 0, timer: null,
};

/* ---------- utilidades ---------- */
const esc = (s) => String(s ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
const fmt = (v, d = 2) => (v == null ? "—" : Number(v).toLocaleString("es", { minimumFractionDigits: d, maximumFractionDigits: d }));
const gbp = (v) => (v == null ? "—" : "£" + fmt(v));
const cut = (s, n) => (s.length > n ? s.slice(0, n - 1) + "…" : s);
const css = (v) => getComputedStyle(document.documentElement).getPropertyValue(v).trim();
const NOMBRE_DEC = { comprar: "Comprar", lista_espera: "Lista de espera", descartar: "Descartar" };
const MOTIVOS = { sin_coincidencia_ol: "Sin datos en Open Library", estrellas_bajo_umbral: "Estrellas bajo el umbral", ediciones_bajo_umbral: "Ediciones bajo el umbral", "": "" };
const badge = (d) => `<span class="badge ${d === "comprar" ? "b-comprar" : d === "lista_espera" ? "b-espera" : "b-descartar"}">${NOMBRE_DEC[d]}</span>`;

async function api(path, params = {}, opts = {}) {
  const u = new URL(path, location.origin);
  for (const [k, v] of Object.entries(params)) {
    if (Array.isArray(v)) v.forEach((x) => u.searchParams.append(k, x));
    else if (v !== null && v !== undefined && v !== "" && v !== false) u.searchParams.set(k, v);
  }
  const r = await fetch(u, opts);
  if (!r.ok) {
    let m = r.statusText;
    try { m = (await r.json()).detail || m; } catch (_) {}
    throw new Error(m);
  }
  return r.json();
}

const umbrales = () => ({ min_estrellas: S.p.me, min_ediciones: S.p.md, top_k: S.p.k });
const filtros = () => ({ categorias: S.f.cat ? [S.f.cat] : [], precio_max: S.f.pmax, q: S.f.q.trim(), solo_coincidencia: S.f.coinc });

/* ---------- gráficos ---------- */
const charts = {};
function chart(id) {
  if (!window.echarts) return null;
  if (!charts[id]) charts[id] = echarts.init($(id));
  return charts[id];
}
function vacio(c, msg) {
  c.clear();
  c.setOption({ title: { text: msg, left: "center", top: "middle", textStyle: { color: css("--muted"), fontSize: 14, fontWeight: "normal" } } }, true);
}
const base = () => ({ textStyle: { color: css("--ink"), fontFamily: "system-ui, sans-serif" }, animationDuration: 350 });
const axisStyle = () => ({ axisLine: { lineStyle: { color: css("--line") } }, axisLabel: { color: css("--muted") }, splitLine: { lineStyle: { color: css("--line") } }, nameTextStyle: { color: css("--muted") } });
const colDec = () => ({ comprar: css("--brand"), lista_espera: css("--amber"), descartar: css("--slate") });

function dibujarTop(d) {
  const c = chart("chTop"); if (!c) return;
  const sel = d.filas.filter((r) => r.decision === "comprar").sort((a, b) => a.prioridad - b.prioridad);
  if (!sel.length) return vacio(c, "Ningún libro cumple la regla con estos umbrales y filtros");
  const nuevos = new Set(d.diferencias.entran.map((x) => x.upc));
  c.setOption({
    ...base(), grid: { left: 8, right: 70, top: 10, bottom: 28, containLabel: true },
    tooltip: { trigger: "item", formatter: (p) => { const r = p.data.r; return `<b>${esc(r.titulo)}</b><br>Prioridad ${r.prioridad} · ${esc(r.categoria)}<br>Indicador: ${fmt(r.indicador)} ediciones/£<br>Precio ${gbp(r.precio_gbp)} · ${r.estrellas}★ · ${r.ediciones_ol} ediciones`; } },
    xAxis: { type: "value", name: "Ediciones por libra (£)", nameLocation: "middle", nameGap: 26, ...axisStyle() },
    yAxis: { type: "category", inverse: true, data: sel.map((r) => `${r.prioridad}. ${cut(r.titulo, 30)}`), axisLabel: { color: css("--ink") }, axisLine: { lineStyle: { color: css("--line") } } },
    series: [{ type: "bar", barMaxWidth: 22, data: sel.map((r) => ({ value: r.indicador, r, itemStyle: { color: nuevos.has(r.upc) ? css("--blue") : css("--brand"), borderRadius: [0, 5, 5, 0] } })),
      label: { show: true, position: "right", color: css("--muted"), formatter: (p) => gbp(p.data.r.precio_gbp) } }],
  }, true);
  c.off("click"); c.on("click", (p) => abrirDetalle(p.data.r.upc));
}

function dibujarScatter(d) {
  const c = chart("chScatter"); if (!c) return;
  const rows = d.filas.filter((r) => r.coincide);
  if (!rows.length) return vacio(c, "Sin libros con datos en ambas fuentes");
  const cd = colDec();
  const serie = (dec, i) => ({
    name: NOMBRE_DEC[dec], type: "scatter", itemStyle: { color: cd[dec], opacity: 0.85 },
    symbolSize: (v) => 6 + v[2] * 3,
    data: rows.filter((r) => r.decision === dec).map((r) => [r.precio_gbp, r.ediciones_ol, r.estrellas, r.titulo, r.upc]),
    markLine: i === 0 ? { silent: true, symbol: "none", lineStyle: { color: css("--rose"), type: "dashed" }, label: { color: css("--rose"), formatter: "umbral " + S.p.md, position: "insideEndTop" }, data: [{ yAxis: S.p.md }] } : undefined,
  });
  c.setOption({
    ...base(), grid: { left: 30, right: 16, top: 62, bottom: 30, containLabel: true },
    legend: { top: 0, textStyle: { color: css("--muted") } },
    tooltip: { formatter: (p) => `<b>${esc(p.data[3])}</b><br>Precio ${gbp(p.data[0])}<br>${p.data[1]} ediciones · ${p.data[2]}★` },
    xAxis: { type: "value", name: "Precio (£)", nameLocation: "middle", nameGap: 26, scale: true, ...axisStyle() },
    yAxis: { type: "value", name: "Ediciones en Open Library", nameLocation: "middle", nameGap: 38, nameTextStyle: { color: css("--muted") }, ...axisStyle() },
    series: ["comprar", "lista_espera", "descartar"].map(serie),
  }, true);
  c.off("click"); c.on("click", (p) => p.data && abrirDetalle(p.data[4]));
}

function dibujarComposicion(d) {
  const c = chart("chComp"); if (!c) return;
  if (!d.composicion.length) return vacio(c, "Sin datos para componer");
  const tot = {}; d.composicion.forEach((r) => (tot[r.categoria] = (tot[r.categoria] || 0) + r.n));
  const cats = Object.keys(tot).sort((a, b) => tot[b] - tot[a]);
  const cd = colDec();
  c.setOption({
    ...base(), grid: { left: 8, right: 16, top: 34, bottom: 8, containLabel: true },
    legend: { top: 0, textStyle: { color: css("--muted") } }, tooltip: { trigger: "axis", axisPointer: { type: "shadow" } },
    xAxis: { type: "value", minInterval: 1, ...axisStyle() },
    yAxis: { type: "category", inverse: true, data: cats, axisLabel: { color: css("--ink") }, axisLine: { lineStyle: { color: css("--line") } } },
    series: ["comprar", "lista_espera", "descartar"].map((dec) => ({
      name: NOMBRE_DEC[dec], type: "bar", stack: "t", itemStyle: { color: cd[dec] },
      data: cats.map((k) => ({ value: (d.composicion.find((r) => r.categoria === k && r.decision === dec) || { n: 0 }).n,
        itemStyle: { color: cd[dec], opacity: !S.f.cat || S.f.cat === k ? 1 : 0.3 } })),
    })),
  }, true);
  c.off("click"); c.on("click", (p) => { S.f.cat = S.f.cat === p.name ? "" : p.name; $("fCategoria").value = S.f.cat; programar(); });
}

function dibujarHistograma(d) {
  const c = chart("chHist"); if (!c) return;
  if (!d.histograma.length) return vacio(c, "Sin indicador calculable");
  const h = d.histograma;
  c.setOption({
    ...base(), grid: { left: 24, right: 12, top: 34, bottom: 30, containLabel: true },
    legend: { top: 0, textStyle: { color: css("--muted") } }, tooltip: { trigger: "axis", axisPointer: { type: "shadow" } },
    xAxis: { type: "category", data: h.map((b) => `${fmt(b.desde, 1)}–${fmt(b.hasta, 1)}`), name: "Ediciones por libra", nameLocation: "middle", nameGap: 28, ...axisStyle(), axisLabel: { color: css("--muted"), fontSize: 10, interval: 0, rotate: 30 } },
    yAxis: { type: "value", minInterval: 1, name: "Libros", nameLocation: "middle", nameGap: 30, nameTextStyle: { color: css("--muted") }, ...axisStyle() },
    series: [
      { name: "Seleccionados", type: "bar", stack: "h", data: h.map((b) => b.comprar), itemStyle: { color: css("--brand") } },
      { name: "Otros libros", type: "bar", stack: "h", data: h.map((b) => b.n - b.comprar), itemStyle: { color: css("--slate") } },
    ],
  }, true);
}

function dibujarEscenarios(cmp) {
  const c = chart("chEsc"); if (!c) return;
  if (!cmp.union.length) return vacio(c, "Ningún escenario tiene libros seleccionados con estos umbrales");
  const col = { base: css("--brand"), esc_cambia_decision: css("--amber"), esc_duplicado: css("--blue") };
  const nombres = Object.fromEntries(cmp.escenarios.map((e) => [e.id, e.corto]));
  c.setOption({
    ...base(), grid: { left: 30, right: 12, top: 64, bottom: 8, containLabel: true },
    legend: { top: 0, textStyle: { color: css("--muted") } },
    tooltip: { trigger: "axis", axisPointer: { type: "shadow" }, formatter: (ps) => `<b>${esc(cmp.union[ps[0].dataIndex].titulo)}</b><br>` + ps.map((p) => { const x = cmp.union[p.dataIndex][p.seriesId]; return `${p.marker} ${p.seriesName}: ${x ? fmt(x.indicador) + " /£ · " + (x.prioridad ? "prioridad " + x.prioridad : "no priorizado") : "—"}`; }).join("<br>") },
    xAxis: { type: "category", data: cmp.union.map((u) => cut(u.titulo, 18)), axisLabel: { color: css("--ink"), rotate: 35, interval: 0, fontSize: 11 }, axisLine: { lineStyle: { color: css("--line") } } },
    yAxis: { type: "value", name: "Ediciones por libra (£)", nameLocation: "middle", nameGap: 36, nameTextStyle: { color: css("--muted") }, ...axisStyle() },
    series: cmp.escenarios.map((e) => ({ id: e.id, name: nombres[e.id], type: "bar", itemStyle: { color: col[e.id] }, barMaxWidth: 16, data: cmp.union.map((u) => (u[e.id] ? u[e.id].indicador : null)) })),
  }, true);
  c.off("click"); c.on("click", (p) => abrirDetalle(cmp.union[p.dataIndex].upc));
}

/* ---------- KPI, banner, simulador ---------- */
function delta(cur, orig, f = (x) => fmt(x, 0), suf = "") {
  if (cur == null || orig == null) return "";
  const d = cur - orig;
  if (Math.abs(d) < 1e-9) return `<span class="muted">= igual que el original</span>`;
  return `<span class="${d > 0 ? "up" : "down"}">${d > 0 ? "▲ +" : "▼ −"}${f(Math.abs(d))}${suf}</span> <span class="muted">vs. original</span>`;
}

function dibujarKpis(d) {
  const k = d.kpis, o = d.kpis_original;
  const items = [
    ["Entidades evaluadas", fmt(k.evaluadas, 0), `<span class="muted">${fmt(k.con_coincidencia, 0)} con datos en Open Library</span>`, ""],
    ["Candidatos que cumplen la regla", fmt(k.candidatos, 0), delta(k.candidatos, o.candidatos), "k-main"],
    ["Libros seleccionados", `${fmt(k.seleccionados, 0)}<small class="muted"> / ${S.p.k}</small>`, delta(k.seleccionados, o.seleccionados), "k-main"],
    ["Cumplimiento de la regla", fmt(k.cumplimiento_pct, 1) + "%", delta(k.cumplimiento_pct, o.cumplimiento_pct, (x) => fmt(x, 1), " pp"), ""],
    ["Costo de la selección", gbp(k.costo), delta(k.costo, o.costo, gbp), ""],
    ["Indicador medio (ediciones/£)", k.indicador_medio == null ? "—" : fmt(k.indicador_medio), delta(k.indicador_medio, o.indicador_medio, (x) => fmt(x)), ""],
  ];
  $("kpis").innerHTML = items.map(([l, v, dl, cls]) => `<div class="kpi ${cls}"><div class="l">${l}</div><div class="v">${v}</div><div class="d">${dl}</div></div>`).join("");
}

function dibujarBanner(d) {
  const k = d.kpis, e = S.meta.escenarios.find((x) => x.id === S.esc);
  const top = d.filas.find((r) => r.prioridad === 1);
  const sinDatos = k.evaluadas - k.con_coincidencia;
  let t = `En el escenario <b>${esc(e.nombre)}</b>, con al menos <b>${S.p.me}★</b> y <b>${S.p.md}</b> ediciones, <b>${fmt(k.candidatos, 0)}</b> de <b>${fmt(k.evaluadas, 0)}</b> libros son candidatos. `;
  t += k.seleccionados ? `Se recomiendan <b>${k.seleccionados}</b> por <b>${gbp(k.costo)}</b>; el primero es «${esc(top.titulo)}» (${fmt(top.indicador)} ediciones por £). ` : `<b>Ningún libro cumple la regla</b>: pruebe bajar los umbrales o relajar los filtros. `;
  if (sinDatos) t += `<br><span class="muted">Atención: ${fmt(sinDatos, 0)} libros no tienen datos en Open Library y no pueden evaluarse.</span>`;
  $("banner").innerHTML = t;
}

function dibujarSimulador(d) {
  const k = d.kpis, o = d.kpis_original, o_p = S.meta.original;
  $("selOrig").textContent = o.seleccionados; $("selOrigTxt").textContent = `${o_p.min_estrellas}★ · ${o_p.min_ediciones} ed. · top ${o_p.top_k}`;
  $("selSim").textContent = k.seleccionados; $("selSimTxt").textContent = `${S.p.me}★ · ${S.p.md} ed. · top ${S.p.k}`;
  const df = d.diferencias, igual = S.p.me === o_p.min_estrellas && S.p.md === o_p.min_ediciones && S.p.k === o_p.top_k;
  const lista = (arr, cls, f) => arr.map((x) => `<span class="pill ${cls}" title="${esc(x.titulo)}">${esc(cut(x.titulo, 26))} ${f(x)}</span>`).join("");
  let h = "";
  if (igual) h = `<span class="muted">Los umbrales coinciden con los originales: no hay diferencias.</span>`;
  else if (!df.entran.length && !df.salen.length && !df.cambian.length) h = `<span class="muted">La selección simulada es idéntica a la original.</span>`;
  else {
    if (df.entran.length) h += `<div><b>Entran (${df.entran.length}):</b> ${lista(df.entran, "in", (x) => "▲ #" + x.posicion)}</div>`;
    if (df.salen.length) h += `<div><b>Salen (${df.salen.length}):</b> ${lista(df.salen, "out", () => "▼")}</div>`;
    if (df.cambian.length) h += `<div><b>Cambian de posición (${df.cambian.length}):</b> ${lista(df.cambian.slice(0, 8), "mv", (x) => `${x.de}→${x.a}`)}${df.cambian.length > 8 ? "…" : ""}</div>`;
  }
  $("difSim").innerHTML = h;
  $("chipSim").classList.toggle("hidden", igual);
}

function dibujarEscCards(cmp) {
  const pill = (arr, cls, f) => arr.map((x) => `<span class="pill ${cls}" title="${esc(x.titulo)}">${esc(cut(x.titulo, 24))} ${f(x)}</span>`).join("");
  $("escCards").innerHTML = cmp.escenarios.map((e) => {
    let ev = "";
    if (e.id !== "base") {
      const df = e.diferencias;
      ev += `<div class="ev"><b>Frente a Base:</b> `;
      ev += df.entran.length || df.salen.length || df.cambian.length
        ? `${df.entran.length} entran · ${df.salen.length} salen · ${df.cambian.length} cambian de posición<br>${pill(df.entran, "in", (x) => "▲ #" + x.posicion)}${pill(df.salen, "out", () => "▼")}`
        : `<span class="ok">Sin diferencias: misma lista y mismo orden ✓</span>`;
      ev += `</div>`;
      ev += e.datos_editados.length
        ? `<div class="ev"><b>Dato editado:</b> ${e.datos_editados.map((x) => `«${esc(cut(x.titulo, 28))}» precio ${gbp(x.precio_base)} → ${gbp(x.precio_variante)}`).join("; ")}</div>`
        : `<div class="ev"><b>Datos de entrada:</b> idénticos a Base. Filas con indicador o prioridad distintos: <b>${e.filas_con_cambio}</b> de ${e.filas}.</div>`;
    }
    return `<div class="esc ${e.id === S.esc ? "act" : ""}"><h4>${esc(e.nombre)}</h4><span class="small muted">${esc(e.descripcion)}</span>
      <div class="nums"><div><span class="small muted">Filas</span><b>${e.filas}</b></div><div><span class="small muted">Candidatos</span><b>${e.candidatos}</b></div><div><span class="small muted">Seleccionados</span><b>${e.seleccionados}</b></div><div><span class="small muted">Costo</span><b>${gbp(e.costo)}</b></div></div>${ev}</div>`;
  }).join("");
}

/* ---------- tabla ---------- */
const COLS = [
  ["prioridad", "Prior.", "num", (r) => r.prioridad ?? "—"],
  ["titulo", "Título", "t", (r) => esc(r.titulo)],
  ["categoria", "Categoría", "", (r) => esc(r.categoria)],
  ["precio_gbp", "Precio", "num", (r) => gbp(r.precio_gbp)],
  ["estrellas", "★", "num", (r) => r.estrellas],
  ["ediciones_ol", "Ediciones", "num", (r) => r.ediciones_ol ?? "—"],
  ["indicador", "Ed./£", "num", (r) => fmt(r.indicador)],
  ["decision", "Decisión", "", (r) => badge(r.decision)],
  ["motivo", "Motivo", "", (r) => esc(MOTIVOS[r.motivo] ?? r.motivo)],
];

function ordenar(rows) {
  const { key, dir } = S.sort;
  return [...rows].sort((a, b) => {
    const x = a[key], y = b[key];
    if (x == null && y == null) return 0; if (x == null) return 1; if (y == null) return -1;
    return (typeof x === "string" ? x.localeCompare(y, "es") : x - y) * dir;
  });
}

function dibujarTabla(d) {
  $("tabla").querySelector("thead").innerHTML = "<tr>" + COLS.map(([k, t, c]) => `<th class="${c}" data-k="${k}" ${S.sort.key === k ? `aria-sort="${S.sort.dir > 0 ? "ascending" : "descending"}" data-arrow="${S.sort.dir > 0 ? "▲" : "▼"}"` : ""}>${t}</th>`).join("") + "</tr>";
  const tb = $("tabla").querySelector("tbody");
  if (!d.filas.length) { tb.innerHTML = `<tr><td colspan="${COLS.length}"><div class="empty">No hay libros con esta combinación de filtros. Use «Restablecer filtros» para volver a la vista general.</div></td></tr>`; return; }
  tb.innerHTML = ordenar(d.filas).map((r) => `<tr tabindex="0" data-u="${esc(r.upc)}">` + COLS.map(([, , c, f]) => `<td class="${c}">${f(r)}</td>`).join("") + "</tr>").join("");
}

$("tabla").addEventListener("click", (e) => {
  const th = e.target.closest("th"); if (th) { const k = th.dataset.k; S.sort = { key: k, dir: S.sort.key === k ? -S.sort.dir : 1 }; return dibujarTabla(S.data); }
  const tr = e.target.closest("tr[data-u]"); if (tr) abrirDetalle(tr.dataset.u);
});
$("tabla").addEventListener("keydown", (e) => { if (e.key === "Enter") { const tr = e.target.closest("tr[data-u]"); if (tr) abrirDetalle(tr.dataset.u); } });

$("btnCsv").addEventListener("click", () => {
  if (!S.data || !S.data.filas.length) return;
  const cab = ["escenario", "prioridad", "upc", "titulo", "categoria", "precio_gbp", "estrellas", "ediciones_ol", "indicador", "decision", "motivo"];
  const q = (v) => `"${String(v ?? "").replace(/"/g, '""')}"`;
  const csv = [cab.join(",")].concat(ordenar(S.data.filas).map((r) => cab.map((c) => q(c === "escenario" ? S.esc : r[c])).join(","))).join("\r\n");
  const a = document.createElement("a"); a.href = URL.createObjectURL(new Blob(["﻿" + csv], { type: "text/csv;charset=utf-8" }));
  a.download = `detalle_${S.esc}.csv`; a.click(); URL.revokeObjectURL(a.href);
});

/* ---------- detalle (drill-down) ---------- */
async function abrirDetalle(upc) {
  $("drawer").classList.remove("hidden"); $("scrim").classList.remove("hidden");
  $("dTitulo").textContent = "Cargando…"; $("dBody").innerHTML = `<div class="skeleton"></div>`;
  try {
    const d = await api("/api/libro/" + encodeURIComponent(upc), umbrales());
    const act = d.escenarios.find((e) => e.escenario === S.esc) || d.escenarios[0];
    $("dTitulo").textContent = act.titulo;
    const ok = (c) => `<span class="${c ? "ok" : "no"}">${c ? "✓ cumple" : "✗ no cumple"}</span>`;
    const regla = act.coincide
      ? `Estrellas: ${act.estrellas} ≥ ${S.p.me} → ${ok(act.estrellas >= S.p.me)}<br>Ediciones: ${act.ediciones_ol} ≥ ${S.p.md} → ${ok(act.ediciones_ol >= S.p.md)}<br>Indicador = ${act.ediciones_ol} ÷ ${gbp(act.precio_gbp)} = <b>${fmt(act.indicador)}</b><br>Resultado: ${badge(act.decision)}${act.prioridad ? ` · prioridad <b>${act.prioridad}</b>` : ""}`
      : `Este libro no tiene coincidencia en Open Library, así que no puede evaluarse la variable de ediciones.<br>Resultado: ${badge(act.decision)}`;
    $("dBody").innerHTML = `<p class="muted small">${esc(act.categoria)} · UPC ${esc(act.upc)} · stock ${act.stock ?? "—"}</p>
      <div class="rule"><b>Regla en «${esc(act.nombre)}»</b><br>${regla}</div>
      <h4>El mismo libro en los tres escenarios</h4>
      <table><thead><tr><th>Escenario</th><th class="num">Precio</th><th class="num">Ed./£</th><th class="num">Prior.</th><th>Decisión</th></tr></thead><tbody>
      ${d.escenarios.map((e) => `<tr><td>${esc(e.nombre)}</td><td class="num">${gbp(e.precio_gbp)}</td><td class="num">${fmt(e.indicador)}</td><td class="num">${e.prioridad ?? "—"}</td><td>${badge(e.decision)}</td></tr>`).join("")}</tbody></table>
      <p class="muted small">Valores recalculados con los umbrales actuales del simulador.</p>`;
  } catch (err) { $("dTitulo").textContent = "No se pudo cargar"; $("dBody").innerHTML = `<div class="alert">${esc(err.message)}</div>`; }
}
function cerrarDetalle() { $("drawer").classList.add("hidden"); $("scrim").classList.add("hidden"); }
$("dCerrar").addEventListener("click", cerrarDetalle); $("scrim").addEventListener("click", cerrarDetalle);
document.addEventListener("keydown", (e) => { if (e.key === "Escape") cerrarDetalle(); });

/* ---------- filtros activos ---------- */
function dibujarActivos() {
  const t = [];
  if (S.f.cat) t.push(["cat", `Categoría: ${S.f.cat}`]);
  if (S.f.pmax != null) t.push(["pmax", `Precio ≤ ${gbp(S.f.pmax)}`]);
  if (S.f.q.trim()) t.push(["q", `Título contiene «${S.f.q.trim()}»`]);
  if (S.f.coinc) t.push(["coinc", "Solo con datos en Open Library"]);
  $("activos").innerHTML = t.length ? `<span class="muted small">Filtros activos:</span>` + t.map(([k, x]) => `<span class="tag">${esc(x)}<button data-x="${k}" aria-label="Quitar filtro">×</button></span>`).join("") : "";
}
$("activos").addEventListener("click", (e) => {
  const k = e.target.dataset.x; if (!k) return;
  if (k === "cat") { S.f.cat = ""; $("fCategoria").value = ""; }
  if (k === "pmax") { S.f.pmax = null; $("fPrecio").value = $("fPrecio").max; }
  if (k === "q") { S.f.q = ""; $("fTexto").value = ""; }
  if (k === "coinc") { S.f.coinc = false; $("fCoinc").checked = false; }
  sincronizar(); programar();
});

/* ---------- ciclo de actualización ---------- */
function sincronizar() {
  $("vPrecio").textContent = S.f.pmax == null ? "sin límite" : gbp(S.f.pmax);
  $("vMe").textContent = S.p.me + " ★"; $("vMd").textContent = S.p.md; $("vK").textContent = S.p.k;
  $("sMe").value = S.p.me; $("sMd").value = S.p.md; $("sK").value = S.p.k;
  const e = S.meta.escenarios.find((x) => x.id === S.esc);
  $("chipEscenario").textContent = "Escenario: " + e.nombre;
}

function programar() { sincronizar(); dibujarActivos(); clearTimeout(S.timer); S.timer = setTimeout(cargar, 180); }

async function cargar() {
  const n = ++S.req;
  $("error").classList.add("hidden");
  if (!S.data) $("kpis").innerHTML = `<div class="skeleton" style="grid-column:1/-1;min-height:96px"></div>`;
  try {
    const [d, cmp] = await Promise.all([api("/api/analisis", { escenario: S.esc, ...umbrales(), ...filtros() }), api("/api/comparacion", umbrales())]);
    if (n !== S.req) return; // llegó una respuesta más nueva
    S.data = d; S.comp = cmp; pintar();
    $("ultima").textContent = "Última consulta a PostgreSQL: " + d.consultado_en.replace("T", " ").slice(0, 19);
  } catch (err) {
    if (n !== S.req) return;
    $("error").textContent = "No se pudieron cargar los datos. " + err.message; $("error").classList.remove("hidden");
    $("banner").innerHTML = "Sin datos para mostrar."; $("kpis").innerHTML = "";
    Object.keys(charts).forEach((k) => vacio(charts[k], "Sin datos"));
  }
}

function pintar() {
  const d = S.data;
  dibujarBanner(d); dibujarKpis(d); dibujarSimulador(d); dibujarTop(d); dibujarScatter(d);
  dibujarComposicion(d); dibujarHistograma(d); dibujarEscCards(S.comp); dibujarEscenarios(S.comp); dibujarTabla(d);
}

/* ---------- arranque ---------- */
async function iniciar() {
  try {
    const m = await api("/api/meta"); S.meta = m;
    const o = m.original; S.p = { me: o.min_estrellas, md: o.min_ediciones, k: o.top_k };
    $("fEscenario").innerHTML = m.escenarios.map((e) => `<option value="${e.id}">${esc(e.nombre)}</option>`).join("");
    $("fCategoria").innerHTML = `<option value="">Todas</option>` + m.categorias.map((c) => `<option value="${esc(c.categoria)}">${esc(c.categoria)} (${c.n})</option>`).join("");
    const pm = Math.ceil(m.rangos.pmax); $("fPrecio").max = pm; $("fPrecio").min = Math.floor(m.rangos.pmin); $("fPrecio").value = pm;
    $("sMd").max = Math.max(20, Math.ceil((m.rangos.emax || 0) / 10) * 10, o.min_ediciones * 2);
    $("sK").max = Math.max(30, o.top_k * 2);
    $("fEscenario").value = S.esc;
    sincronizar(); await cargar();
  } catch (err) { $("error").textContent = "No se pudo iniciar la aplicación. " + err.message; $("error").classList.remove("hidden"); $("banner").classList.add("hidden"); $("ultima").textContent = ""; }
}

$("fEscenario").addEventListener("change", (e) => { S.esc = e.target.value; programar(); });
$("fCategoria").addEventListener("change", (e) => { S.f.cat = e.target.value; programar(); });
$("fPrecio").addEventListener("input", (e) => { const v = +e.target.value; S.f.pmax = v >= +e.target.max ? null : v; programar(); });
$("fTexto").addEventListener("input", (e) => { S.f.q = e.target.value; programar(); });
$("fCoinc").addEventListener("change", (e) => { S.f.coinc = e.target.checked; programar(); });
$("sMe").addEventListener("input", (e) => { S.p.me = +e.target.value; programar(); });
$("sMd").addEventListener("input", (e) => { S.p.md = +e.target.value; programar(); });
$("sK").addEventListener("input", (e) => { S.p.k = +e.target.value; programar(); });
$("btnReset").addEventListener("click", () => {
  S.f = { cat: "", pmax: null, q: "", coinc: false };
  $("fCategoria").value = ""; $("fPrecio").value = $("fPrecio").max; $("fTexto").value = ""; $("fCoinc").checked = false; programar();
});
$("btnResetSim").addEventListener("click", () => { const o = S.meta.original; S.p = { me: o.min_estrellas, md: o.min_ediciones, k: o.top_k }; programar(); });
$("btnRefrescar").addEventListener("click", async () => {
  const b = $("btnRefrescar"); b.disabled = true; b.textContent = "Actualizando…";
  try { await api("/api/refrescar", {}, { method: "POST" }); await cargar(); } catch (err) { $("error").textContent = err.message; $("error").classList.remove("hidden"); }
  b.disabled = false; b.textContent = "Actualizar datos";
});
window.addEventListener("resize", () => Object.values(charts).forEach((c) => c.resize()));
matchMedia("(prefers-color-scheme: dark)").addEventListener("change", () => S.data && pintar());

iniciar();
