<template>
  <div class="loading">
    <div class="timer" />
  </div>
</template>

<script lang="ts">
export default {
};

</script>

<style scoped lang="scss">
@import '@/scss/colors';

/* Source: https://codepen.io/viduthalai1947/pen/JkhDK */

/* Timer */

$timer-color: $color-black;

.timer {
  width: 1.5rem;
  height: 1.5rem;
  background-color: transparent;
  box-shadow: inset 0px 0px 0px 2px $timer-color;
  border-radius: 50%;
  position: relative;
  margin: 2.375rem auto; /* Not necessary- its only for layouting*/
 }

.timer:after, .timer:before {
  position: absolute;
  content:"";
  background-color: $timer-color;
}

.timer:after {
  width: .625rem;
  height: .125rem;
  top: .6875rem;
  left: .6875rem;
  -webkit-transform-origin: 1px 1px;
      -moz-transform-origin: 1px 1px;
          transform-origin: 1px 1px;
  -webkit-animation: minhand 2s linear infinite;
      -moz-animation: minhand 2s linear infinite;
          animation: minhand 2s linear infinite;
}

.timer:before {
  width: 8px;
  height: .125rem;
  top: .6875rem;
  left: .6875rem;
  -webkit-transform-origin: 1px 1px;
      -moz-transform-origin: 1px 1px;
          transform-origin: 1px 1px;
  -webkit-animation: hrhand 8s linear infinite;
      -moz-animation: hrhand 8s linear infinite;
          animation: hrhand 8s linear infinite;
}

@-webkit-keyframes minhand {
  0%{-webkit-transform:rotate(0deg)}
  100%{-webkit-transform:rotate(360deg)}
}

@-moz-keyframes minhand {
  0%{-moz-transform:rotate(0deg)}
  100%{-moz-transform:rotate(360deg)}
}

@keyframes minhand {
  0%{transform:rotate(0deg)}
  100%{transform:rotate(360deg)}
}

@-webkit-keyframes hrhand {
  0%{-webkit-transform:rotate(0deg)}
  100%{-webkit-transform:rotate(360deg)}
}

@-moz-keyframes hrhand {
  0%{-moz-transform:rotate(0deg)}
  100%{-moz-transform:rotate(360deg)}
}

@keyframes hrhand {
  0%{transform:rotate(0deg)}
  100%{transform:rotate(360deg)}
}
</style>
