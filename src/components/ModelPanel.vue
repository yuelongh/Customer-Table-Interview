<template>
  <div class="modal" @click.self="props.close_window()">
    <div @click.self="props.close_window()">
      <div class="modal-content">
        <div class="header">
          <span class="close" @click="props.close_window()">
            <font-awesome-icon class="icon" icon="xmark" size="2x" />
          </span>
        </div>
        <div class="content">
          <slot name="content"></slot>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {
  library,
  type IconDefinition,
} from "@fortawesome/fontawesome-svg-core";
import { faXmark } from "@fortawesome/free-solid-svg-icons";

library.add(faXmark as IconDefinition);
const props = defineProps({
  close_window: {
    type: Function,
    required: true,
  },
});
</script>

<style scoped lang="scss">
/* The Modal (background) */
.modal {
  display: block;
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0, 0, 0); /* Fallback color */
  background-color: rgba(0, 0, 0, 0.4); /* Black w/ opacity */

  /* Modal Content */
  .modal-content {
    border-radius: 20px;
    background-color: #fefefe;
    margin: 20% auto;
    border: 1px solid #888;
    width: 95%;
    padding: 0 1%;

    > .header {
      margin-top: 1%;
      min-height: 20px;
      width: 85%;

      > .close {
      }
    }

    > .content {
      padding: 1% 2%;
    }
  }

  /* The Close Button */
  .close:hover,
  .close:focus {
    color: #000;
    text-decoration: none;
    cursor: pointer;
  }
}
</style>
