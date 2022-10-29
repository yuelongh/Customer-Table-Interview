import { createApp } from "vue";
import { createPinia } from "pinia";
import App from "./App.vue";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";

const app = createApp(App);

/*** to import vuex ***/
app.use(createPinia());

/*** to import fontawesome ***/
app.component("font-awesome-icon", FontAwesomeIcon);
/*** to mount to element #app ***/
app.mount("#app");
