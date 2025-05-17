document.addEventListener("turbo:before-stream-render", (event) => {
  const stream = event.target;

  if (stream.action === "replace" && stream.target.startsWith("bookmark-button-for-word-")) {
    const wordId = stream.target.split("bookmark-button-for-word-")[1];

    const newElement = stream.templateElement.content.firstElementChild;
    const allTargets = document.querySelectorAll(`#bookmark-button-for-word-${wordId}`);

    allTargets.forEach((target) => {
      const cloned = newElement.cloneNode(true);
      target.replaceWith(cloned);
    });

    event.preventDefault();
  }
});
