<template>
  <main>
    <h1 class="header">Customer Information Table</h1>
    <customer-table />
  </main>
</template>

<script setup lang="ts">
import CustomerTable from "@/components/CustomerTable.vue";
</script>

<style lang="scss">
/***** import fortawesome For loading icon *****/
@import "../node_modules/@fortawesome/fontawesome-free/css/all.min.css";

main {
  margin: 10% 0;
  h1.header {
    text-align: center;
  }
}

.icon {
  margin-right: 1%;

  :hover {
    color: red;
    cursor: pointer;
  }
}

.loading_spinner:before {
  content: "";
  background: rgba(0, 0, 0, 0);
  position: fixed;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  z-index: 1000;
}

.loading_spinner:after {
  content: "\f1ce";
  font-family: "Font Awesome 5 Free";
  font-weight: 900;
  font-size: 300%;
  position: fixed;
  width: 100%;
  top: 50%;
  left: 0;
  z-index: 1001;
  color: #0f00ff;
  text-align: center;
  -webkit-animation: spin 2s linear infinite;
  -moz-animation: spin 2s linear infinite;
  animation: spin 2s linear infinite;
}

@-moz-keyframes spin {
  100% {
    -moz-transform: rotate(360deg);
  }
}

@-webkit-keyframes spin {
  100% {
    -webkit-transform: rotate(360deg);
  }
}

@keyframes spin {
  100% {
    -webkit-transform: rotate(360deg);
    transform: rotate(360deg);
  }
}
</style>
