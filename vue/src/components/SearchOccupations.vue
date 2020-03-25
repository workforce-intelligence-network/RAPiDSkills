<template>
  <form class="search" @submit.prevent="submitSearchDebounced" @keyup.esc="closeSearch">
    <input class="input__input search__input" type="text" name="search" placeholder="Search by occupation name" @focus="onFocus" ref="searchInput" v-model="query" autocomplete="off" @click.stop.prevent="() => {}" />
    <a class="search__button" href="javascript:void(0)" @click.stop.prevent="onClickSearchButton">
      <img :src=ICON_TOP_NAV_SEARCH alt="Search Icon" class="search__button__icon" />
    </a>
    <Tour :id="TOUR_STEP_ID_STANDARDS_OCCUPATION_SEARCH" />
    <div class="search__dropdown" v-if="showList">
      <div class="search__dropdown__empty" v-if="!listLoading && !list.length">
        No occupations found.
      </div>
      <div class="search__dropdown__loading" v-if="listLoading">
        <Loading />
      </div>
      <div class="search__dropdown__list" v-if="!listLoading">
        <a class="search__dropdown__list__item" v-for="item in list" :key="item.id" @click.stop.prevent="selectItem(item)" href="javascript:void(0);">
          <OccupationCell :occupation="item" />
        </a>
      </div>
    </div>
  </form>
</template>

<script lang="ts">
import _get from 'lodash/get';
import _debounce from 'lodash/debounce';

import { mapGetters, mapState } from 'vuex';

import ICON_TOP_NAV_SEARCH from '@/assets/top-nav-icon-search.svg';

import Loading from '@/components/Loading.vue';
import OccupationCell from '@/components/OccupationCell.vue';
import Tour from '@/components/Tour.vue';

import {
  TOUR_STEP_ID_STANDARDS_OCCUPATION_SEARCH,
} from '@/store/tours';

export default {
  components: {
    OccupationCell,
    Loading,
    Tour,
  },
  created() {
    (this as any).submitSearchDebounced = _debounce((this as any).submitSearchDebounced, 500).bind(this);
    (this as any).onBodyClick = (this as any).onBodyClick.bind(this);
  },
  updated() {
    if ((this as any).showList) {
      document.body.addEventListener('click', (this as any).onBodyClick);
    } else {
      document.body.removeEventListener('click', (this as any).onBodyClick);
    }
  },
  destroyed() {
    document.body.removeEventListener('click', (this as any).onBodyClick);
  },
  methods: {
    onBodyClick() {
      if (!(this as any).showList) {
        return;
      }

      (this as any).closeSearch();
    },
    closeSearch() {
      ((this as any).$refs.searchInput as any).blur();
      (this as any).$store.dispatch('occupations/hideOccupationsList');
    },
    onFocus() {
      (this as any).inputValue = '';
      if ((this as any).selectedOccupation) {
        (this as any).$store.dispatch('occupations/setSelectedOccupation');
      }
      (this as any).submitSearch();
    },
    onClickSearchButton() {
      if ((this as any).showList) {
        (this as any).closeSearch();
        return;
      }

      (this as any).submitSearch();
    },
    submitSearchDebounced() {
      (this as any).submitSearch();
    },
    submitSearch() {
      (this as any).$store.dispatch('occupations/searchForOccupations', (this as any).query);
    },
    selectItem(item) {
      (this as any).$store.dispatch('occupations/setSelectedOccupation', item);
    },
  },
  data() {
    return {
      inputValue: '',
      ICON_TOP_NAV_SEARCH,
      TOUR_STEP_ID_STANDARDS_OCCUPATION_SEARCH,
    };
  },
  computed: {
    ...mapGetters({
      showList: 'occupations/showOccupationSearchList',
    }),
    ...mapState({
      list: (state: any) => state.occupations.list,
      listLoading: (state: any) => state.occupations.loading,
      listEmpty: (state: any) => !state.occupations.list.length,
      selectedOccupation: (state: any) => state.occupations.selectedOccupation,
    }),
    query: {
      get() {
        if ((this as any).selectedOccupation) {
          return (this as any).selectedOccupation.title;
        }

        return (this as any).inputValue;
      },
      set(value) {
        (this as any).inputValue = value;
        (this as any).submitSearchDebounced();
      },
    },
  },
};

</script>

<style scoped lang="scss">
@import "@/scss/mixins";
@import "@/scss/colors";

$search-button-width: 3rem;

.search {
  position: relative;
}

.search__input {
  width: 25rem;
  padding-right: $search-button-width;

  @include breakpoint--sm {
    width: 100%;
  }
}

.search__button {
  position: absolute;
  top: 0;
  bottom: 0;
  right: 0;
  width: $search-button-width;
  display: flex;
  justify-content: center;
}

.search__dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  min-width: 100%;
  min-height: 5rem;
  max-height: 20rem;
  background: $color-white;
  overflow: auto;
  border: 1px solid $color-gray-border;
  box-shadow: 0 10px 20px 0 transparentize($color-link-blue, 0.9);
}

.search__dropdown__list__item {
  display: block;
  color: $color-black;
  cursor: pointer;
  border-bottom: 1px solid $color-gray-border;

  &:hover {
    background: darken($color: $color-white, $amount: 10);
  }
}

.search__dropdown__empty,
.search__dropdown__loading {
  line-height: 5rem;
}

</style>
