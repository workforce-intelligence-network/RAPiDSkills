<template>
  <div class="occupation-cell">
    <!-- <div class="occupation-cell__logo">
    </div> -->
    <div class="occupation-cell__title">
      {{ occupation.title }}
    </div>
    <!-- <div class="occupation-cell__meta">
    </div> -->
  </div>
</template>

<script lang="ts">
export default {
  props: {
    occupation: Object,
  },
};

</script>

<style scoped lang="scss">
.occupation-cell {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-content: space-between;
  align-items: center;
  height: 3rem;
  padding: 0 1rem;
}

.occupation-cell__logo {
  /* width: .5rem; */
}

.occupation-cell__title {
  display: flex;
  justify-content: flex-start;
  flex-grow: 1;
  text-align: left;
  font-weight: 500;
}
</style>
