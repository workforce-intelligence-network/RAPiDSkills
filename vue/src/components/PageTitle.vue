<template>
  <div class="page-title">
    {{ title }}
  </div>
</template>

<script lang="ts">
import _get from 'lodash/get';
import _isFunction from 'lodash/isFunction';

const DEFAULT_PAGE_TITLE = '';

export default {
  computed: {
    title() {
      const title = _get(this, '$route.meta.pageTitle', DEFAULT_PAGE_TITLE);
      if (_isFunction(title)) {
        return title() || DEFAULT_PAGE_TITLE;
      }
      return title;
    },
  },
};

</script>

<style scoped lang="scss">
.page-title {
  width: 100%;
  text-align: left;
  font-size: 1.25rem;
  padding: 0 1rem;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}
</style>
