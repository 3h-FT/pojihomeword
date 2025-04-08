document.addEventListener('DOMContentLoaded', () => {
    const allSituations = JSON.parse(document.getElementById('situations-data').dataset.situations);
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