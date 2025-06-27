document.addEventListener('turbo:load', () => {
  // --- シチュエーションの絞り込み ---
  const dataElement = document.getElementById('situations-data');
  if (dataElement) {
    const allSituations = JSON.parse(dataElement.dataset.situations);
    const targetSelect = document.getElementById('target_id');
    const situationSelect = document.getElementById('situation_id');
    const situationContainer = document.getElementById('situation-container');

    function updateSituationsForTarget(targetId) {
      if (situationContainer) {
        situationContainer.style.display = 'none';
      }

      situationSelect.innerHTML = '<option value="">シチュエーションを選んでください</option>';

      const filtered = allSituations.filter(s => s.target_id == targetId);
      if (filtered.length > 0) {
        filtered.forEach(s => {
          const option = document.createElement('option');
          option.value = s.id;
          option.textContent = s.name;
          situationSelect.appendChild(option);
        });

        if (situationContainer) {
          situationContainer.style.display = 'block';
        }
      }
    }

    if (targetSelect) {
      targetSelect.addEventListener('change', (e) => {
        updateSituationsForTarget(e.target.value);
      });
    }
  }

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
  }
});