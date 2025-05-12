document.addEventListener('turbo:load', () => {
  const dataElement = document.getElementById('situations-data');
  if (!dataElement) return;

  const allSituations = JSON.parse(dataElement.dataset.situations);
  const targetSelect = document.getElementById('target_id');
  const situationSelect = document.getElementById('situation_id');
  const situationContainer = document.getElementById('situation-container');

  // シチュエーションをターゲットIDに基づいて更新する関数
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

  // ターゲットの選択変更時にシチュエーションを更新
  targetSelect.addEventListener('change', (e) => {
    updateSituationsForTarget(e.target.value);
  });

  // コピー機能を追加
  document.querySelectorAll('.copy-button').forEach(button => {
    button.addEventListener('click', () => {
      const content = button.getAttribute('data-word');
      navigator.clipboard.writeText(content)
        .then(() => {
          alert('コピーしました!');
        })
        .catch(err => {
          console.error('コピーに失敗しました: ', err);
        });
    });
  });
});
