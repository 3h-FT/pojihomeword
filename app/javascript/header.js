document.addEventListener('turbo:load', () => {
  const dropdownButton = document.getElementById('positive-dropdown-button');
  const dropdownMenu = document.getElementById('positive-dropdown-menu');
  const hamburgerButton = document.getElementById('hamburger-button');
  const mobileMenu = document.getElementById('mobile-menu');

  // ▼ ポジティブワード ドロップダウン
  if (dropdownButton && dropdownMenu) {
    dropdownButton.addEventListener('click', (event) => {
      event.stopPropagation();
      dropdownMenu.classList.toggle('hidden');
    });

    document.addEventListener('click', (event) => {
      if (!dropdownButton.contains(event.target) && !dropdownMenu.contains(event.target)) {
        dropdownMenu.classList.add('hidden');
      }
    });
  }

  // 共有サブメニュー（デスクトップ）
  const shareDropdownButtonDesktop = document.getElementById('share-dropdown-button-desktop');
  const shareDropdownMenuDesktop = document.getElementById('share-dropdown-menu-desktop');

  if (shareDropdownButtonDesktop && shareDropdownMenuDesktop) {
    shareDropdownButtonDesktop.addEventListener('click', (event) => {
      event.stopPropagation();
      shareDropdownMenuDesktop.classList.toggle('hidden');
    });

    document.addEventListener('click', (event) => {
      if (!shareDropdownButtonDesktop.contains(event.target) && !shareDropdownMenuDesktop.contains(event.target)) {
        shareDropdownMenuDesktop.classList.add('hidden');
      }
    });
  }

  // ☰ ハンバーガーメニュー
  if (hamburgerButton && mobileMenu) {
    hamburgerButton.addEventListener('click', () => {
      mobileMenu.classList.toggle('hidden');
    });
  }

  // 共有サブメニュー（モバイル）
  const shareDropdownButtonMobile = document.getElementById('share-dropdown-button-mobile');
  const shareDropdownMenuMobile = document.getElementById('share-dropdown-menu-mobile');

  if (shareDropdownButtonMobile && shareDropdownMenuMobile) {
    shareDropdownButtonMobile.addEventListener('click', (event) => {
      event.stopPropagation();
      shareDropdownMenuMobile.classList.toggle('hidden');
    });

    document.addEventListener('click', (event) => {
      if (!shareDropdownButtonMobile.contains(event.target) && !shareDropdownMenuMobile.contains(event.target)) {
        shareDropdownMenuMobile.classList.add('hidden');
      }
    });
  }
});
