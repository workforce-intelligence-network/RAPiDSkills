<template>
  <div class="page--home">
    <div class="page--home__hero">
      <img alt="RapidSkills Logo" :src="APP_LOGO" class="page--home__hero__logo" />
      <div class="page--home__text page--home__hero__text page--home__hero__text--title">
        Create competency-based apprenticeships in a snap!
      </div>
      <div class="page--home__text page--home__hero__text page--home__hero__text--description">
        <span>RapidSkills takes the pain out of creating competency-based apprenticeships from scratch.</span>
        <span> Time-based programs will be supported soon, too! Follow now to find out when we launch.</span>
      </div>
      <div class="page--home__links">
        <router-link :to="{ name: 'signup' }" class="button button--inverted page--home__links__button page--home__links__button--follow">
          Get started
        </router-link>
        <router-link :to="{ name: 'standards' }" class="button button--link button--link--alternative page--home__links__button page--home__links__button--browse">
          Browse Standards
        </router-link>
      </div>
      <LaptopPreview class="page--home__hero__laptop-preview" />
    </div>
    <div class="page--home__how-it-works">
      <div class="page--home__text page--home__how-it-works__text page--home__how-it-works__text--title">
        How it works
      </div>
      <div class="page--home__text page--home__how-it-works__text page--home__how-it-works__text--appeal">
        <span>Leverage content from high-quality apprenticeship programs</span>
        <span> to quickly and easily create your custom competency list!</span>
      </div>
      <div class="page--home__how-it-works__cards">
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_SEARCH_DATABASE" alt="Search the Database Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Search the Database</div>
          <div class="page--home__how-it-works__cards__card__description">
            Search by occupation or job title to view existing skill and competency outlines from the database.
          </div>
        </div>
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_SAVE_CLONE" alt="Save & Clone Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Save & Clone</div>
          <div class="page--home__how-it-works__cards__card__description">
            Easily save and make a copy of your favorites to customize for your needs.
          </div>
        </div>
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_EDIT_CUSTOMIZE" alt="Edit & Customize Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Edit & Customize</div>
          <div class="page--home__how-it-works__cards__card__description">
            Add, remove, and modify skills and work processes to customize for your apprenticeship program.
          </div>
        </div>
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_LEVERAGE_SKILLS" alt="Leverage Existing Skills Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Leverage Existing Skills</div>
          <div class="page--home__how-it-works__cards__card__description">
            Find and add related skills from other outlines as you customize your own.
          </div>
        </div>
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_DOWNLOAD_PDF" alt="Download PDF or Excel Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Download PDF or Excel</div>
          <div class="page--home__how-it-works__cards__card__description">
            Download or email your customized competency outline into a common format for sharing with partners.
          </div>
        </div>
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_SHARE_WITH_OTHERS" alt="Share with Others Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Share with Others</div>
          <div class="page--home__how-it-works__cards__card__description">
            Share with others by entering an email address - RapidSkills will send an invite so your contacts can collaborate.
          </div>
        </div>
      </div>
    </div>
    <div class="page--home__follow">
      <img alt="RapidSkills Logo" :src="APP_LOGO" class="page--home__hero__logo" />
      <div class="page--home__text page--home__follow__text page--home__follow__text--call-to-action">
        <div>
          <span>Sign up now to find out when we launch or contribute your own competency outlines.</span>
        </div>
        <div class="page--home__follow__text--call-to-action__bold">
          Get started today
        </div>
      </div>
      <div class="page--home__links">
        <router-link :to="{ name: 'signup' }" class="button button--inverted page--home__links__button page--home__links__button--follow">
          Get started
        </router-link>
        <router-link :to="{ name: 'standards' }" class="button button--link button--link--alternative page--home__links__button page--home__links__button--browse">
          Browse Standards
        </router-link>
      </div>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import LaptopPreview from '@/components/LaptopPreview.vue';

import APP_LOGO from '@/assets/app-logo.svg';

import ICON_SEARCH_DATABASE from '@/assets/search-database.svg';
import ICON_SAVE_CLONE from '@/assets/save-clone.svg';
import ICON_EDIT_CUSTOMIZE from '@/assets/edit-customize.svg';
import ICON_LEVERAGE_SKILLS from '@/assets/leverage-skills.svg';
import ICON_DOWNLOAD_PDF from '@/assets/download-pdf.svg';
import ICON_SHARE_WITH_OTHERS from '@/assets/share-with-others.svg';

export default {
  name: 'home',
  components: {
    LaptopPreview,
  },
  data() {
    return {
      APP_LOGO,
      ICON_SEARCH_DATABASE,
      ICON_SAVE_CLONE,
      ICON_EDIT_CUSTOMIZE,
      ICON_LEVERAGE_SKILLS,
      ICON_DOWNLOAD_PDF,
      ICON_SHARE_WITH_OTHERS,
    };
  },
};
</script>

<style scoped lang="scss">
@import "@/scss/colors";
@import "@/scss/mixins";

.page--home {
  text-align: center;
}

.page--home__hero__laptop-preview,
.page--home__text {
  margin: 0 auto;
}

.page--home__text {
  max-width: 36rem;
  padding: 0rem 1rem;
  margin: 0 auto;
}

.page--home__hero {
  padding-top: 6rem;
}

.page--home__follow__logo,
.page--home__hero__logo {
  color: $color-white;
  font-size: 2rem;
  margin-bottom: 2rem;
}

.page--home__hero__text {
  color: $color-white;
}

.page--home__hero__text--title {
  font-size: 2.75rem;
  margin-bottom: 1.5rem;
  font-weight: 500;
}

.page--home__hero__text--description {
  font-size: 1.125rem;
  line-height: 1.75rem;
  margin-bottom: 2rem;
}

.page--home__links {
  display: inline-block;
  margin-top: 1rem;
  margin-bottom: 3rem;
}

.page--home__links__button {
  &:not(:last-child) {
    margin-right: 1rem;
  }
}

.page--home__links__button--browse {
  padding: .7rem .5rem;
}

.page--home__hero__laptop-preview {
  margin-bottom: 3rem;
  min-height: 20rem;
  @include breakpoint--sm {
    min-height: auto;
  }
}

.page--home__how-it-works {
  padding-bottom: 6rem;
  @include breakpoint--sm {
    padding-bottom: 2rem;
  }
}

.page--home__how-it-works__text--title {
  color: $color-link-blue;
  font-size: 1.125rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
}

.page--home__how-it-works__text--appeal {
  font-size: 1.75rem;
  line-height: 2.5rem;
  margin-bottom: 1.5rem;
}

.page--home__how-it-works__text--description {
  font-size: 1rem;
  line-height: 1.75rem;
  margin-bottom: 3rem;
  max-width: 26rem;
}

.page--home__how-it-works__cards__card,
.page--home__how-it-works__cards {
  display: flex;
}

.page--home__how-it-works__cards {
  align-items: center;
  justify-content: space-evenly;
  flex-wrap: wrap;
  max-width: 70rem;
  margin: 0 auto;
}

.page--home__how-it-works__cards__card {
  background: $color-white;
  border: 1px solid #f2f2f2;
  box-shadow: 0 10px 20px 0 transparentize($color-link-blue, 0.9);
  flex-direction: column;
  align-items: center;
  justify-content: space-evenly;
  max-width: 19rem;
  padding: 0 1.5rem;
  padding-bottom: 1.5rem;
  height: 24rem;
  margin: 1rem 0.5rem;
}

.page--home__how-it-works__cards__card__title {
  font-size: 1.5rem;
  font-weight: 500;
}

.page--home__how-it-works__cards__card__description {
  height: 8rem;
  font-size: 1.125rem;
  line-height: 2rem;
}

.page--home__follow {
  padding: 5rem 0;
  background-image: url("../assets/home-hero-background.svg");
  background-position: left;
  background-size: cover;
}

.page--home__follow__text {
  color: $color-white;
}

.page--home__follow__text--call-to-action {
  font-size: 2rem;
  line-height: 2.75rem;
  margin-bottom: 2rem;
}

.page--home__follow__text--call-to-action__bold {
  margin-top: 1rem;
  font-weight: 600;
}
</style>
