document.addEventListener("turbo:load", () => {
  const buttons = document.querySelectorAll(".tab-button");
  const contents = document.querySelectorAll("[data-tab-content]");

  if (buttons.length === 0 || contents.length === 0) return;

  // 初期アクティブタブ取得
  const activeButton = Array.from(buttons).find(btn => btn.getAttribute("aria-selected") === "true");
  if (activeButton) {
    setActiveTab(activeButton.getAttribute("data-tab"));
  }

  // タブクリック時の処理
  buttons.forEach(button => {
    button.addEventListener("click", () => {
      const target = button.getAttribute("data-tab");
      setActiveTab(target);

      // URLの更新
      const url = new URL(window.location);
      url.searchParams.set("tab", target);
      history.replaceState(null, "", url);
    });
  });

  function setActiveTab(target) {
    // コンテンツの切り替え
    contents.forEach(content => {
      content.classList.add("hidden");
    });
    const showContent = document.querySelector(`[data-tab-content="${target}"]`);
    if (showContent) showContent.classList.remove("hidden");

    // ボタンの見た目を更新
    buttons.forEach(btn => {
      btn.className = "tab-button py-2 px-10 font-semibold transition duration-300 ease-in-out focus:outline-none";
      const defaultClass = btn.getAttribute("data-default-class");
      if (defaultClass) {
        defaultClass.split(" ").forEach(c => btn.classList.add(c));
      }
    });

    // アクティブなタブに色付け
    const activeBtn = document.querySelector(`.tab-button[data-tab="${target}"]`);
    if (activeBtn) {
      activeBtn.classList.remove("bg-blue-100", "bg-green-50", "bg-yellow-100", "text-gray-700", "hover:bg-gray-200", "hover:bg-green-200", "hover:bg-yellow-200");
      if (target === "all") {
        activeBtn.classList.add("bg-blue-200", "text-blue-600");
      } else if (target === "custom") {
        activeBtn.classList.add("bg-green-200", "text-green-700");
      } else if (target === "favorite") {
        activeBtn.classList.add("bg-yellow-200", "text-yellow-700");
      }
    }
  }
});
