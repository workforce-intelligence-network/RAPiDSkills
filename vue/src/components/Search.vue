<template>
  <div class="search">
    <input class="input__input search__input" type="text" name="search" placeholder="Search by occupation name" @input="onSearchChange" />
    <a class="search__button" href="javascript:void(0)" @click="onSearchChange">
      <img :src=ICON_TOP_NAV_SEARCH alt="Search Icon" class="search__button__icon" />
    </a>
    <div class="search__dropdown" v-if="showList">
      <div class="search__dropdown__loading" v-if="listLoading">
        Loading...
      </div>
      <div class="search__dropdown__list" v-if="!listLoading">
        <div class="search__dropdown__list__item" v-for="item in list" :key="item.id" @click="selectItem(item)">
          <OccupationCell :occupation="item" />
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import _get from 'lodash/get';
import _throttle from 'lodash/throttle';

import { mapGetters, mapState } from 'vuex';

import ICON_TOP_NAV_SEARCH from '@/assets/top-nav-icon-search.svg';

import OccupationCell from '@/components/OccupationCell.vue';

export default {
  components: {
    OccupationCell,
  },
  created() {
    (this as any).onSearchChange = _throttle((this as any).onSearchChange, 500).bind(this);
  },
  methods: {
    onSearchChange(e) {
      (this as any).$store.dispatch('occupations/searchForOccupations', _get(e, 'target.value'));
    },
    selectItem(item) {
      (this as any).$store.dispatch('occupations/setSelectedOccupation', item);
    },
  },
  data() {
    return {
      ICON_TOP_NAV_SEARCH,
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
    }),
  },
};

</script>

<style scoped lang="scss">
@import '@/scss/mixins';
@import '@/scss/colors';

$search-button-width: 3rem;

.search {
  position: relative;
}

.search__input {
  width: 25rem;
  padding-right: $search-button-width;

  @include breakpoint--mobile {
    width: auto;
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
  border: 1px solid #f2f2f2;
  box-shadow: 0 10px 20px 0 transparentize(#459EFF, .9);
}

.search__dropdown__list__item {
  cursor: pointer;

  &:hover {
    background: darken($color: $color-white, $amount: 10);
  }
}

.search__dropdown__loading {
  line-height: 5rem;
}
</style>
