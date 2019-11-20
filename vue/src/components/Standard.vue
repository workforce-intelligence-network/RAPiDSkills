<template>
  <div class="standard">
    <div class="standard__label">{{ label }}</div>
    <div class="standard__logo">
      <img :src="standard.organization.logo" :alt="standard.organization.name" class="standard__logo__logo" />
    </div>
    <div class="standard__occupation-name">{{ standard.occupation.name }}</div>
    <div class="standard__occupation-metadata">
      <div class="standard__occupation-metadata__item standard__occupation-metadata__type">{{ standard.occupation.type }}</div>
      <div class="standard__occupation-metadata__item standard__occupation-metadata__onet">{{ standard.occupation.onet }}</div>
      <div class="standard__occupation-metadata__item standard__occupation-metadata__cb">{{ standard.occupation.cb }}</div>
    </div>
    <div class="standard__divider--stats" />
    <div class="standard__work-process-data">
      <div class="standard__work-process-data__stat">
        <div class="standard__work-process-data__stat__number">{{ standard.workProcesses.length }}</div>
        <div class="standard__work-process-data__stat__text">Work</div>
        <div class="standard__work-process-data__stat__text">Processes</div>
      </div>
      <div class="standard__work-process-data__stat">
        <div class="standard__work-process-data__stat__number">{{ totalNumberOfCompetencies }}</div>
        <div class="standard__work-process-data__stat__text">Total</div>
        <div class="standard__work-process-data__stat__text">Competencies</div>
      </div>
      <div class="standard__work-process-data__stat">
        <div class="standard__work-process-data__stat__number">{{ totalNumberOfHours }}</div>
        <div class="standard__work-process-data__stat__text">Total</div>
        <div class="standard__work-process-data__stat__text">Hours</div>
      </div>
    </div>
    <!-- <div class="standard__divider" />
    <div class="standard__actions">
      <button class="button button--secondary button--round standard__actions__button--save">
        X
      </button>
    </div> -->
  </div>
</template>

<script lang="ts">
import ICON_LEFT_NAV_HEART from '@/assets/left-nav-icon-heart.svg';

export default {
  props: {
    standard: Object,
    label: String,
  },
  data() {
    return {
      ICON_LEFT_NAV_HEART,
    };
  },
  computed: {
    totalNumberOfCompetencies() {
      return ((this as any).standard as any).workProcesses
        .reduce((total, workProcess) => total + workProcess.skills.length, 0);
    },
    totalNumberOfHours() {
      return ((this as any).standard as any).workProcesses
        .reduce((total, workProcess) => total + workProcess.hoursTotal, 0);
    },
  },
};

</script>

<style scoped lang="scss">
@import '@/scss/colors';

.standard {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-content: space-between;
  max-width: 18rem;
  width: 18rem;
  border-radius: 4px;
  background: $color-white;
  box-shadow: $color-nav-bar-top-box-shadow 0px 2px 4px 0px;
}

.standard__label {
  background: $color-black;
  color: $color-white;
  text-transform: uppercase;
  font-weight: 800;
  padding: 0.5rem 1.5rem;
  align-self: center;
  border-bottom-left-radius: 3px;
  border-bottom-right-radius: 3px;
  font-size: .7rem;
  letter-spacing: 0.1ch;
}

.standard__logo {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 6rem;
}

.standard__occupation-name {
  font-size: 1.75rem;
  margin-bottom: .5rem;
}

.standard__logo__logo {
  max-width: 100%;
  max-height: 100%;
}

.standard__occupation-metadata {
  display: flex;
  flex-direction: row;
  justify-content: center;
}

.standard__occupation-metadata__item {
  opacity: .5;

  &:not(:last-child) {
    margin-right: .75rem;
  }
}

.standard__divider--stats {
  height: 3px;
  width: 2rem;
  border-bottom: 3px solid $color-blue;
  align-self: center;
  margin-top: 1rem;
  margin-bottom: 1.5rem;
}

.standard__work-process-data {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  justify-content: space-between;
  margin-bottom: 1.5rem;
}

.standard__work-process-data__stat__number {
  font-weight: 700;
  margin-bottom: .5rem;
}

.standard__work-process-data__stat__text {
  opacity: .6;
}

.standard__divider {
  height: 1px;
  border-bottom: 1px solid lightgrey;
  width: 100%;
}

.standard__actions {
  display: flex;
  flex-direction: row;
  padding: .5rem;
}

.standard__actions__button--save {
  height: 2rem;
  width: 2rem;
  line-height: 1rem;
  font-size: 1rem;
  text-align: center;
  align-self: flex-start;
}
</style>
