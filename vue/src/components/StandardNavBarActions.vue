<template>
  <div class="standard__navbar-actions">
    <PageTitle />
    <div class="standard__navbar-actions__state" v-if="userIsCreator">
      <div class="standard__navbar-actions__state__text" v-if="loading">Updating...</div>
      <div class="standard__navbar-actions__state__text" v-if="valid && !loading" v-html="lastUpdated()" />
      <div class="standard__navbar-actions__state__text standard__navbar-actions__state__text--error" v-if="!valid && !loading">Standard invalid.</div>
      <button class="button standard__navbar-actions__state__button__button" :disabled="loading || !valid" @click="saveStandard">
        Save
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import _clone from 'lodash/clone';
import _sortBy from 'lodash/sortBy';
import _flatten from 'lodash/flatten';

import Vue from 'vue';

import {
  Component,
} from 'vue-property-decorator';

import moment, { Moment } from 'moment';
import PageTitle from '@/components/PageTitle.vue';
import Loading from '@/components/Loading.vue';
import OccupationStandard from '@/models/OccupationStandard';
import WorkProcess from '@/models/WorkProcess';
import Skill from '@/models/Skill';
import { update } from '../store/modal/actions';

@Component({
  components: {
    Loading,
    PageTitle,
  },
})
export default class StandardNavBarActions extends Vue {
  intervalId?: number

  mounted() {
    this.intervalId = setInterval(() => {
      this.$forceUpdate();
    }, 10000);
  }

  destroyed() {
    clearInterval(this.intervalId);
  }

  async saveStandard() {
    if (!this.standard.save) {
      return;
    }

    const promises: Promise<any>[] = [];

    try {
      promises.push(this.standard.save());
    } catch (e) {
      (Vue as any).rollbar.error(e);
    }

    // TODO: only if dirty?
    this.standard.workProcesses.forEach((workProcess: WorkProcess) => {
      try {
        promises.push(workProcess.save());
      } catch (e) {
        (Vue as any).rollbar.error(e);
      }

      workProcess.skills.forEach((skill: Skill) => {
        try {
          promises.push(skill.save());
        } catch (e) {
          (Vue as any).rollbar.error(e);
        }
      });
    });

    this.standard.skills.forEach((skill: Skill) => {
      try {
        promises.push(skill.save());
      } catch (e) {
        (Vue as any).rollbar.error(e);
      }
    });

    try {
      await Promise.all(promises);
    } catch (e) {
      (Vue as any).rollbar.error(e);
    }

    this.$store.dispatch('standards/refreshSelectedStandard');

    this.standard.updatedAt = moment().format();
  }

  protected get standard(): OccupationStandard {
    return this.$store.state.standards.selectedStandard || {};
  }

  protected get valid() {
    return this.standard.valid;
  }

  protected get loading() {
    return this.$store.getters['standards/selectedStandardLoading'];
  }

  protected get userIsCreator() {
    return this.standard.loggedInUserIsCreator;
  }

  lastUpdated() {
    if (!this.standard.updatedAt) {
      return 'Up to date';
    }

    const secondsDifference: number = Math.abs(
      moment(this.standard.updatedAt).diff(moment(), 'seconds'),
    );

    if (secondsDifference < 60) {
      return 'Updated just now';
    }

    const minutesDifference: number = Math.floor(secondsDifference / 60);

    if (minutesDifference < 60) {
      return `Updated ${minutesDifference} minute${minutesDifference === 1 ? '' : 's'} ago`;
    }

    const hoursDifference: number = Math.floor(minutesDifference / 60);

    return `Updated ${hoursDifference} hours${hoursDifference === 1 ? '' : 's'} ago`;
  }
}
</script>

<style scoped lang="scss">
@import '@/scss/colors';

.standard__navbar-actions {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  flex-wrap: nowrap;
  align-items: center;
  width: 100%;
  text-align: left;
}

.standard__navbar-actions__state {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  flex-wrap: nowrap;
  margin-right: 1rem;
}

.standard__navbar-actions__state__text {
  min-width: 7rem;
  text-align: center;
  white-space: nowrap;
  color: $color-text-light;
  padding: 0 1rem;
}

.standard__navbar-actions__state__text--error {
  color: $color-salmon;
}

.standard__navbar-actions__state__button {
  padding-right: .5rem;
  margin-right: .5rem;
  border-right: 1px solid $color-gray-light;
}
</style>
