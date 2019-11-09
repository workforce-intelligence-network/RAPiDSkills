<template>
  <div class="laptop-preview">
    <img class="laptop-preview__image" :src="LAPTOP_PREVIEW" alt="Website Preview" />
  </div>
</template>

<script lang="ts">
import LAPTOP_PREVIEW from '@/assets/laptop-preview.png';

export default {
  data() {
    return {
      LAPTOP_PREVIEW,
    };
  },
};

</script>

<style scoped lang="scss">
.laptop-preview {
  max-width: 56rem;
  text-align: center;
}

.laptop-preview__image {
  width: 100%;
}
</style>
