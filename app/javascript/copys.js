document.addEventListener('turbo:load', () => {
  console.log('✅ turbo:load 発火確認');

  document.querySelectorAll('.copy-button').forEach(button => {
    console.log('🎯 ボタン発見:', button);
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