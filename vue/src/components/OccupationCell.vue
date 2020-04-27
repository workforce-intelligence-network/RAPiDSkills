<template>
  <div class="occupation-cell">
    <div class="occupation-cell__title">
      {{ occupation.title }}
    </div>
    <div class="occupation-cell__codes">
      <div class="occupation-cell__codes__code occupation-cell__codes__code--rapid">
        {{ occupation.rapidsCode }}
      </div>
      <div class="occupation-cell__codes__code occupation-cell__codes__code--onet">
        {{ occupation.onetCode }}
      </div>
    </div>
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
@import "@/scss/colors";

.occupation-cell {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: .5rem 1rem;
}

.occupation-cell__codes {
  display: flex;
  justify-content: flex-end;
  color: $color-text-light;
}

.occupation-cell__codes__code {
  &:not(:first-child) {
    margin-left: 1.5rem;
  }
}

.occupation-cell__title {
  margin-bottom: .25rem;
  text-align: left;
  font-weight: 500;
}
</style>
