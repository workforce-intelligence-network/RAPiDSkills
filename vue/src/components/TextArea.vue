<template>
  <textarea v-bind="$attrs" class="textarea" @input="onInput($event)" />
</template>

<script lang="ts">
import Vue from 'vue';
import {
  Component, Prop,
} from 'vue-property-decorator';

@Component
export default class TextArea extends Vue {
  updateHeight() {
    this.$el.setAttribute('style', '');
    this.$el.setAttribute('style', `min-height: ${this.$el.scrollHeight}px`);
  }

  onInput($event) {
    this.updateHeight();
    this.$emit('input', $event.target.value);
  }

  mounted() {
    this.updateHeight();
    setTimeout(() => this.updateHeight());
  }
}
</script>

<style scoped lang="scss">
.textarea {
  resize: none;
  overflow: hidden;
}
</style>
