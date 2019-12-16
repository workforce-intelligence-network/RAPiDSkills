<template>
  <div class="search">
    <input class="input__input search__input" type="text" name="search" placeholder="Search by standard or occupation name" />
    <a class="search__button" href="javascript:void(0)">
      <img :src=ICON_TOP_NAV_SEARCH alt="Search Icon" class="search__button__icon" />
    </a>
  </div>
</template>

<script lang="ts">
import ICON_TOP_NAV_SEARCH from '@/assets/top-nav-icon-search.svg';

export default {
  data() {
    return {
      ICON_TOP_NAV_SEARCH,
    };
  },
};

</script>

<style scoped lang="scss">
$search-button-width: 3rem;

.search {
  position: relative;
}

.search__input {
  width: 25rem;
  padding-right: $search-button-width;
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
</style>
