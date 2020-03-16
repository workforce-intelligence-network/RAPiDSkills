<template>
  <router-link class="standard" :to="routerLink">
    <div class="standard__label">{{ label }}</div>
    <div class="standard__logo">
      <img :src="standard.organizationLogoUrl" :alt="standard.organizationTitle" class="standard__logo__logo" />
    </div>
    <div class="standard__occupation-name">{{ standard.title }}</div>
    <div class="standard__occupation-metadata">
      <div class="standard__occupation-metadata__item standard__occupation-metadata__type">{{ standard.occupationKind }}</div>
      <div class="standard__occupation-metadata__item standard__occupation-metadata__onet">{{ standard.occupationOnetCode || 'ONET' }}</div>
      <div class="standard__occupation-metadata__item standard__occupation-metadata__cb">{{ standard.occupationRapidsCode || 'Rapid' }}</div>
    </div>
    <div class="standard__divider--stats" />
    <div class="standard__work-process-data">
      <div class="standard__work-process-data__stat">
        <div class="standard__work-process-data__stat__number">{{ standard.workProcessesCount }}</div>
        <div class="standard__work-process-data__stat__text">Work</div>
        <div class="standard__work-process-data__stat__text">Processes</div>
      </div>
      <div class="standard__work-process-data__stat">
        <div class="standard__work-process-data__stat__number">{{ standard.skillsCount }}</div>
        <div class="standard__work-process-data__stat__text">Total</div>
        <div class="standard__work-process-data__stat__text">Skills</div>
      </div>
      <div class="standard__work-process-data__stat">
        <div class="standard__work-process-data__stat__number">{{ standard.hoursCount }}</div>
        <div class="standard__work-process-data__stat__text">Total</div>
        <div class="standard__work-process-data__stat__text">Hours</div>
      </div>
    </div>
    <div class="standard__divider" v-if="!saved && sessionActive" />
    <div class="standard__actions" v-if="!saved && sessionActive">
      <Tooltip class="standard__actions__action" tip="Favorite" v-if="!standard.favorited">
        <button class="button button--link standard__actions__action__button standard__actions__action__button--left standard__actions__action__button--favorite" @click.prevent="favoriteStandard">
          <FontAwesomeIcon :icon="['fas', 'heart']" class="standard__actions__action__button__icon standard__actions__action__button__icon--fa" />
        </button>
      </Tooltip>
      <Tooltip class="standard__actions__action" tip="Unfavorite" v-if="standard.favorited">
        <button class="button button--link standard__actions__action__button standard__actions__action__button--left" @click.prevent="unfavoriteStandard">
          <FontAwesomeIcon :icon="['fas', 'heart']" class="standard__actions__action__button__icon standard__actions__action__button__icon--fa" />
        </button>
      </Tooltip>
      <Tooltip class="standard__actions__action standard__actions__action--right" tip="Duplicate">
        <button class="button button--link standard__actions__action__button standard__actions__action__button--right" @click.prevent="duplicateStandard">
          <img :src="ICON_DUPLICATE_ALT" alt="Duplicate" class="standard__actions__action__button__icon" />
        </button>
      </Tooltip>
    </div>
  </router-link>
</template>

<script lang="ts">
import { mapGetters } from 'vuex';

import Tooltip from '@/components/Tooltip.vue';
import ICON_DUPLICATE_ALT from '@/assets/icon-duplicate-alt.svg';


export default {
  components: {
    Tooltip,
  },
  props: {
    standard: Object,
    label: String,
    saved: Boolean,
  },
  methods: {
    duplicateStandard() {
      (this as any).$store.dispatch('standards/updateStandardToDuplicate', (this as any).standard);

      (this as any).$router.push({
        name: 'duplicate',
        params: {
          id: (this as any).standard.id,
        },
      });
    },
  },
  data() {
    return {
      ICON_DUPLICATE_ALT,
    };
  },
  computed: {
    ...mapGetters({
      sessionActive: 'session/isActive',
    }),
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
  height: 8rem;
  padding: 1rem;
}

.standard__logo__logo {
  max-width: 100%;
  height: 100%;
}

.standard__occupation-name {
  font-size: 1.75rem;
  line-height: 2.25rem;
  margin-bottom: 1rem;
  padding: 0 1.5rem;
  height: 4.5rem;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
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
  border-bottom: 1px solid $color-gray-light;
  width: 100%;
}

.standard__actions {
  display: flex;
  flex-direction: row;
  height: 3rem;
}

.standard__actions__action__button {
  height: 3rem;
  width: 3rem;
  padding: .75rem;
}

.standard__actions__action--right {
  margin-left: auto;
}

.standard__actions__action__button__icon {
  height: 100%;
}

.standard__actions__action__button__icon--fa {
  width: 1.125rem;
}

.standard__actions__action__button--favorite {
  color: $color-black-lighter;
}
</style>
