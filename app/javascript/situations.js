document.addEventListener('turbo:load', () => {
  // --- ローディングアニメーション設定 ---
  const form = document.getElementById('ai-message-form');
  const submitButton = document.getElementById('submit-button');
  const fullPageLoading = document.getElementById('full-page-loading');
  const loadingMessage = document.getElementById('loading-message');

  const messages = [
    "ポジティブなワードを生成中...",
    "あなたの想いを形にしています...",
    "心に響く言葉を紡いでいます...",
  ];
  let messageIndex = 0;
  let messageInterval;

  if (form) {
    form.addEventListener('submit', () => {
      submitButton.disabled = true;
      fullPageLoading.classList.remove('hidden');

      loadingMessage.textContent = messages[messageIndex];
      messageInterval = setInterval(() => {
        messageIndex = (messageIndex + 1) % messages.length;
        loadingMessage.textContent = messages[messageIndex];
      }, 2000);
    });
  }
});

document.addEventListener('turbo:load', () => {
  const resultSection = document.getElementById('result-section');
  if (resultSection) {
    resultSection.scrollIntoView({ behavior: 'smooth' });

    // 紙吹雪を発射
    launchConfetti();
  }
});

function launchConfetti() {
  const container = document.getElementById('confetti-container');
  if (!container) return;

  const colors = ['#f43f5e', '#fb7185', '#fca5a5', '#f87171', '#fbbf24'];
  const count = 30;

  for (let i = 0; i < count; i++) {
    const confetti = document.createElement('div');
    confetti.classList.add('confetti-piece');
    confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];

    confetti.style.left = `${window.innerWidth / 2 + (Math.random() * 100 - 50)}px`;
    confetti.style.top = `${window.innerHeight / 4 + (Math.random() * 30 - 15)}px`;

    const animationDuration = 1500 + Math.random() * 1000;
    const translateX = (Math.random() - 0.5) * 300;
    const translateY = 300 + Math.random() * 200;
    const rotate = Math.random() * 720;

    confetti.animate([
      { transform: 'translate(0, 0) rotate(0deg)', opacity: 1 },
      { transform: `translate(${translateX}px, ${translateY}px) rotate(${rotate}deg)`, opacity: 0 }
    ], {
      duration: animationDuration,
      easing: 'ease-out',
      fill: 'forwards'
    });

    container.appendChild(confetti);

    setTimeout(() => {
      confetti.remove();
    }, animationDuration);
  }
}
