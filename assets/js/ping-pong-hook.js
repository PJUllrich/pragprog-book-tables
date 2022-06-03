export default {
  addPongListener() {
    window.addEventListener("phx:pong", (event) => {
      console.log(event.type);
      console.log(event.detail.message);
    });
  },
  sendPing() {
    this.pushEvent("ping", { myVar: 1 });
  },
  mounted() {
    console.log("I'm alive!");
    this.addPongListener();
    this.sendPing();
  },
};
