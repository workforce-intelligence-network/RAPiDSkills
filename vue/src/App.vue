<template>
  <div id="app" class="app">
    <router-view />
  </div>
</template>

<style lang="scss">
@import url('https://fonts.googleapis.com/css?family=Livvic:100,200,300,400,500,600,700,900&display=swap');
@import url('https://fonts.googleapis.com/css?family=Heebo:300,400,500,700&display=swap');

html, body {
  font-size: 16px;
  margin: 0;
  padding: 0;
  height: 100%;
  width: 100%;
  overflow-x: hidden;
  overflow-y: auto;
  font-family: 'Livvic', 'Heebo', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  background: #FAFBFC;
}

body * {
  box-sizing: border-box;
}

a {
  &, &:hover {
    text-decoration: none;
  }
}

.app {
  position: relative;
  height: 100%;
  width: 100%;
  overflow: auto;
}

.button {
  border-radius: 25px;
  font-size: 1rem;
  padding: .7rem 1.5rem;
  font-weight: 600;

  color: white;
  background: #459EFF;

  cursor: pointer;

  &:hover {
    background: #0073FF;
  }

  &, &:hover {
    text-decoration: none;
  }
}

.button--link,
.button--inverted {
  color: #459EFF;
  &:hover {
    color: #0073FF;
  }
}

.button--inverted {
  background: white;
  &:hover {
    background: darken(white, 10);
  }
}

.button--link {
  padding: 0;
  &, &:hover {
    background: none;
  }
}

.button--secondary {
  background: lightgray;
  color: darkgray;

  &:hover {
    background: darken($color: lightgray, $amount: 20);
    color: black;
  }
}

.button--round {
  padding: 0.5rem;
  border-radius: 50%;
}

.input {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.input--spaced {
  margin-bottom: 1rem;
}

.input--error .input__input {
  border-color: salmon;
  &::placeholder {
    color: salmon;
  }
}

.input--error .input__label {
  color: salmon;
}

.input__label {
  font-size: 1rem;
  margin-bottom: .5rem;
  cursor: pointer;
}

.input__input {
  border-radius: 4px;
  margin: 0;
  padding: 0 .5rem;
  font-size: 1rem;
  outline: none;
  border: 1px solid #f2f2f2;
  font-family: 'Livvic', 'Heebo', Helvetica, Arial, sans-serif;
  &:focus {
    outline: dashed 1px #459EFF;
    outline-offset: 4px;
  }
}

.input__input:not(textarea) {
  height: 2.75rem;
}
</style>
