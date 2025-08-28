(function(){
  const sidebar = document.querySelector('.sidebar');
  const toggle = document.getElementById('sidebarToggle');
  if(toggle){
    toggle.addEventListener('click',()=>{
      sidebar.classList.toggle('open');
    });
  }

  // Draw simple sparkline charts with seeded randomness
  document.querySelectorAll('.spark').forEach((canvas)=>{
    const ctx = canvas.getContext('2d');
    const w = canvas.width = canvas.clientWidth; 
    const h = canvas.height = canvas.clientHeight;
    const seed = Number(canvas.dataset.seed || 30);
    let x = 0;
    const step = w/24;
    const base = h*0.6;
    ctx.strokeStyle = '#2a2d31';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(0, base);
    for(let i=0;i<24;i++){
      const variance = (Math.sin(i*0.6)+Math.cos(i*0.35))*5 + (seed/100)*h*0.2;
      const y = base - variance + Math.random()*8;
      x += step;
      ctx.lineTo(x, y);
    }
    ctx.stroke();
  });

  // Donut chart
  const donut = document.getElementById('donut');
  if(donut){
    const ctx = donut.getContext('2d');
    const size = Math.min(donut.clientWidth, donut.clientHeight);
    donut.width = size; donut.height = size;
    const center = size/2; const radius = center-8; const thickness = 18;
    const segments = [0.62, 0.28, 0.10];
    const colors = ['#3EE15B','#AAAAAA','#656965'];

    let start = -Math.PI/2;
    segments.forEach((p,idx)=>{
      const end = start + p*2*Math.PI;
      ctx.beginPath();
      ctx.arc(center, center, radius, start, end);
      ctx.lineWidth = thickness;
      ctx.strokeStyle = colors[idx];
      ctx.lineCap = 'round';
      ctx.stroke();
      start = end + 0.03; // small gap
    });

    // Inner cutout
    ctx.globalCompositeOperation = 'destination-out';
    ctx.beginPath();
    ctx.arc(center, center, radius-thickness, 0, Math.PI*2);
    ctx.fill();
    ctx.globalCompositeOperation = 'source-over';
  }
})();

