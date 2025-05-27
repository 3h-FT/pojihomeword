document.addEventListener('turbo:load', () => {
  const dataElement = document.getElementById('situations-data');
  if (!dataElement) return;

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

  targetSelect.addEventListener('change', (e) => {
    updateSituationsForTarget(e.target.value);
  });
});

document.addEventListener('turbo:load', () => {
  const form = document.getElementById('ai-message-form');
  const submitButton = document.getElementById('submit-button');
  const spinner = document.getElementById('loading-spinner');

  if (form) {
    form.addEventListener('submit', () => {
        console.log("ローディング表示中！");
      submitButton.disabled = true;
      spinner.classList.remove('hidden');
    });
  }
});