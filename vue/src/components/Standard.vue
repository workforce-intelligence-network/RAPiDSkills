<template>
  <router-link class="standard" :to="routerLink">
    <div class="standard__label">{{ label }}</div>
    <div class="standard__logo">
      <img :src="standard.organization.logoUrl" :alt="standard.organizationTitle" class="standard__logo__logo" />
    </div>
    <div class="standard__occupation-name">{{ standard.title }}</div>
    <div class="standard__occupation-metadata">
      <div class="standard__occupation-metadata__item standard__occupation-metadata__type">{{ standard.occupation.kind }}</div>
      <div class="standard__occupation-metadata__item standard__occupation-metadata__onet">{{ standard.occupation.onetCode }}</div>
      <div class="standard__occupation-metadata__item standard__occupation-metadata__cb">{{ standard.occupation.rapidsCode }}</div>
    </div>
    <div class="standard__divider--stats" />
    <div class="standard__work-process-data">
      <div class="standard__work-process-data__stat">
        <div class="standard__work-process-data__stat__number">{{ standard.workProcesses.length }}</div>
        <div class="standard__work-process-data__stat__text">Work</div>
        <div class="standard__work-process-data__stat__text">Processes</div>
      </div>
      <div class="standard__work-process-data__stat">
        <div class="standard__work-process-data__stat__number">{{ standard.totalNumberOfSkills }}</div>
        <div class="standard__work-process-data__stat__text">Total</div>
        <div class="standard__work-process-data__stat__text">Skills</div>
      </div>
      <div class="standard__work-process-data__stat">
        <div class="standard__work-process-data__stat__number">{{ standard.totalNumberOfHours }}</div>
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
  </router-link>
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
    routerLink() {
      return {
        name: 'standard',
        params: {
          id: (this as any).standard.id,
        },
      };
    },
  },
};

</script>

<style scoped lang="scss">
@import "@/scss/colors";
@import "@/scss/standards";
@import "@/scss/mixins";

.standard {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-content: space-between;
  max-width: $standard-width;

  @include breakpoint--xs {
    max-width: 100%;
    min-width: auto;
  }

  @include breakpoint--above-xs {
    min-width: $standard-width;
    width: $standard-width;
  }

  background: $color-white;
  box-shadow: $color-nav-bar-top-box-shadow 0px 2px 4px 0px;
  cursor: pointer;
  color: initial;
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
  font-size: 0.7rem;
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
  line-height: 2.25rem;
  margin-bottom: 1rem;
  padding: 0 1.5rem;
  height: 4.5rem;
  overflow: hidden;
  text-overflow: ellipsis;
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
  opacity: 0.5;

  &:not(:last-child) {
    margin-right: 0.75rem;
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
  margin-bottom: 0.5rem;
}

.standard__work-process-data__stat__text {
  opacity: 0.6;
}

.standard__divider {
  height: 1px;
  border-bottom: 1px solid lightgrey;
  width: 100%;
}

.standard__actions {
  display: flex;
  flex-direction: row;
  padding: 0.5rem;
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
