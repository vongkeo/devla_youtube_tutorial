## Internationalization (i18n) in Vue.js 2 with vue-i18n #delva #vuejs #i18n

### Install the package
```bash
yarn add vue-i18n@8
```

### Create the locales files 
```json
# en.json
{
  "greeting": "Hello",
  "welcome": "Welcome to our application"
}

# la.json
{
  "greeting": "ສະບາຍດີ",
  "welcome": "ຍິນດີຕ້ອນຮັບສູ່ແອັບພິເກຊັນຂອງເຮົາ"
}

```

### Create Plugin
```js
import Vue from "vue";
import VueI18n from "vue-i18n";

import en from "@/locales/en.json";
import la from "@/locales/la.json";

Vue.use(VueI18n);

const messages = {
  en: en,
  la: la,
};

const savedLocale = localStorage.getItem("locale") || "en";

const i18n = new VueI18n({
  locale: savedLocale, // set default locale from localStorage
  fallbackLocale: "en", // set fallback locale
  messages, // set locale messages
});

export default i18n;

```
### Register Plugin in main.js
```js
import i18n from "@/plugins/i18n";
const app = new Vue({
  i18n,
  render: (h) => h(App),
});
```
### Use in component
```html
<template>
  <div class="home">
    <h1>
      {{ $t("greeting") }}
    </h1>
    <p>
      {{ $t("welcome") }}
    </p>
    <button @click="changeLanguage('en')">English</button>
    <button @click="changeLanguage('la')">Lao</button>
  </div>
</template>

<script>
// @ is an alias to /src
import HelloWorld from "@/components/HelloWorld.vue";

export default {
  name: "HomeView",
  components: {
    HelloWorld,
  },
  methods: {
    changeLanguage(lang) {
      localStorage.setItem("locale", lang);
      this.$i18n.locale = lang;
    },
  },
};
</script>
```
