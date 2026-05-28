const TOTAL = 4;
let cur = 0;

const track = document.getElementById("track");
track.style.width = `${TOTAL * 100}%`;
track.querySelectorAll(".page").forEach(p => p.style.width = `${100 / TOTAL}%`);

async function loadPages() {
  for (let i = 0; i < TOTAL; i++) {
    const res = await fetch(`pages/page${i + 1}.html`);
    const html = await res.text();
    document.getElementById(`p${i}`).innerHTML = html;
  }
}

function goTo(n) {
  cur = Math.max(0, Math.min(TOTAL - 1, n));

  document.getElementById("track").style.transform =
    `translateX(-${cur * (100 / TOTAL)}%)`;

  document.getElementById("page-label").textContent =
    `Page ${cur + 1} of ${TOTAL}`;

  document.getElementById("btn-prev").disabled = cur === 0;
  document.getElementById("btn-next").disabled = cur === TOTAL - 1;

  for (let i = 0; i < TOTAL; i++)
    document.getElementById(`dot-${i}`).classList.toggle("active", i === cur);
}

function step(dir) { goTo(cur + dir); }

document.addEventListener("keydown", e => {
  if (e.key === "ArrowRight" || e.key === "ArrowDown") step(1);
  if (e.key === "ArrowLeft"  || e.key === "ArrowUp")   step(-1);
});

loadPages();
