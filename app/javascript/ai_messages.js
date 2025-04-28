document.addEventListener('DOMContentLoaded', () => {
  console.log("DOMContentLoaded 起動しました");

  const form = document.getElementById('generate-form');
  const resultContainer = document.getElementById('result-container');
  const aiMessage = document.getElementById('ai-message');
  const regenerateButton = document.getElementById('regenerate-button');

  if (!form) {
    console.error('generate-formが見つかりません');
    return;
  }

  form.addEventListener('ajax:success', (event) => {
    console.log("ajax:success イベント発火");
    const [data, status, xhr] = event.detail;
    console.log('受信データ:', data);

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
      if (resultContainer) {
        resultContainer.style.display = 'none';
      }
      // form.reset(); // これをコメントアウトすると、フォームの内容が保持されたままになります
    });
  }
});