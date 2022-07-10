export default {
  rootElement() {
    return (
      document.documentElement || document.body.parentNode || document.body
    );
  },
  scrollPosition() {
    const { scrollTop, clientHeight, scrollHeight } = this.rootElement();

    return ((scrollTop + clientHeight) / scrollHeight) * 100;
  },
  scrollEventListener() {
    const currentScrollPosition = this.scrollPosition();

    const isCloseToBottom =
      currentScrollPosition > this.threshold &&
      this.lastScrollPosition <= this.threshold;

    if (isCloseToBottom) this.pushEvent("load-more", {});

    this.lastScrollPosition = currentScrollPosition;
  },
  mounted() {
    this.threshold = 90;
    this.lastScrollPosition = 0;

    window.addEventListener("scroll", () => this.scrollEventListener());
  },
  destroyed() {
    // Upon destruction of the table, we need to remove the event listener again.
    // Otherwise, we might end up with multiple listeners that might fetch data from dead LiveViews.
    // This change was suggested by `Nicolas Blanco` here: https://github.com/PJUllrich/pragprog-book-tables/issues/1
    // Thank you very much, Nicolas!
    window.removeEventListener("scroll", () => this.scrollEventListener());
  },
};
