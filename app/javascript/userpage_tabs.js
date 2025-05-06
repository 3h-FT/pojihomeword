document.addEventListener("turbo:load", () => {
  const buttons = document.querySelectorAll(".tab-button");
  const contents = document.querySelectorAll("[data-tab-content]");

  if (buttons.length === 0 || contents.length === 0) return;

  buttons.forEach(button => {
    button.addEventListener("click", () => {
      const target = button.getAttribute("data-tab");

      // タブコンテンツの表示切り替え
      contents.forEach(content => {
        content.classList.add("hidden");
      });

      const showContent = document.querySelector(`[data-tab-content="${target}"]`);
      if (showContent) showContent.classList.remove("hidden");

      // URLを書き換えて ?tab=xxx を保持
      const url = new URL(window.location);
      url.searchParams.set("tab", target);
      history.replaceState(null, "", url);
    });
  });
});
