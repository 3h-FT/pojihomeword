document.addEventListener('turbo:load', () => {

  const form = document.getElementById('generate-form');
  if (!form) return;

  if (form.dataset.listenerAttached === "true") return;

  const resultContainer = document.getElementById('result-container');
  const aiMessage = document.getElementById('ai-message');
  const regenerateButton = document.getElementById('regenerate-button');

  form.addEventListener('ajax:success', (event) => {
    const [data, status, xhr] = event.detail;

    if (data && data.word) {
      aiMessage.textContent = data.word;
      resultContainer.style.display = 'block';
    } else {
      console.error('受信データの形式が想定と違います', data);
    }
  });

  if (regenerateButton) {
    regenerateButton.addEventListener('click', (e) => {
      e.preventDefault();
      resultContainer.style.display = 'none';
    });
  }

  form.dataset.listenerAttached = "true";
});
