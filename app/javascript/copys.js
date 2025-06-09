document.addEventListener('turbo:load', () => {
  document.querySelectorAll('.copy-button').forEach(button => {
    // すでにバインドされていればスキップ（無限増殖防止）
    if (button.dataset.copyBound) return;

    button.dataset.copyBound = "true";

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