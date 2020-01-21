<template>
  <div class="page--home">
    <div class="page--home__hero">
      <img alt="RapidSkills Logo" :src="APP_LOGO" class="page--home__hero__logo" />
      <div class="page--home__text page--home__hero__text page--home__hero__text--title">
        Create new apprenticeship standards in a snap!
      </div>
      <div class="page--home__text page--home__hero__text page--home__hero__text--description">
        <span>Finally an easy-to-use application that takes the pain out of</span>
        <span> creating new apprenticeship standards from scratch.</span>
      </div>
      <div>
        <router-link :to="{ name: 'follow' }">
          <button class="button button--inverted page--home__hero__button page--home__hero__button--follow">
            Follow us
          </button>
        </router-link>
        <router-link :to="{ name: 'standards' }">
          <button class="button button--link page--home__hero__button page--home__hero__button--follow button--link--alternative">
            Browse Standards
          </button>
        </router-link>
      </div>
      <LaptopPreview class="page--home__hero__laptop-preview" />
    </div>
    <div class="page--home__how-it-works">
      <div class="page--home__text page--home__how-it-works__text page--home__how-it-works__text--title">
        How it works
      </div>
      <div class="page--home__text page--home__how-it-works__text page--home__how-it-works__text--appeal">
        <span>Stop starting from scratch and start</span>
        <span> leveraging content from approved standards!</span>
      </div>
      <div class="page--home__text page--home__how-it-works__text page--home__how-it-works__text--description">
        <span>RapidSkills uses smart technology to help you streamline</span>
        <span> your process saving you time and the frustration of</span>
        <span> having to create new standards from scratch.</span>
      </div>
      <div class="page--home__how-it-works__cards">
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_SEARCH_DATABASE" alt="Search the Database Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Search the Database</div>
          <div class="page--home__how-it-works__cards__card__description">
            Access and review thousands of similar standards by searching the RapidSkills Occupation Database.
          </div>
        </div>
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_SAVE_CLONE" alt="Save & Clone Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Save & Clone</div>
          <div class="page--home__how-it-works__cards__card__description">
            Easily save and clone similar standards for as a starting point for your own customized work processes.
          </div>
        </div>
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_EDIT_CUSTOMIZE" alt="Edit & Customize Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Edit & Customize</div>
          <div class="page--home__how-it-works__cards__card__description">
            Once you’ve created a clone of a similar standard RapidSkills makes it super easy to customize and create new standards.
          </div>
        </div>
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_LEVERAGE_SKILLS" alt="Leverage Existing Skills Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Leverage Existing Skills</div>
          <div class="page--home__how-it-works__cards__card__description">
            RapidSkills is smart and helps you find existing related skills as you customize and edit your new apprenticeship standards.
          </div>
        </div>
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_DOWNLOAD_PDF" alt="Download PDF or Excel Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Download PDF or Excel</div>
          <div class="page--home__how-it-works__cards__card__description">
            Download your digital standard into a common document form for your records and easy sharing and distribution.
          </div>
        </div>
        <div class="page--home__how-it-works__cards__card">
          <img :src="ICON_SHARE_WITH_OTHERS" alt="Share with Others Icon" class="page--home__how-it-works__cards__card__icon" />
          <div class="page--home__how-it-works__cards__card__title">Share with Others</div>
          <div class="page--home__how-it-works__cards__card__description">
            Simply share with others by entering an email address - RapidSkills will send an invite so your contacts can collaborate.
          </div>
        </div>
      </div>
    </div>
    <div class="page--home__follow">
      <img alt="RapidSkills Logo" :src="APP_LOGO" class="page--home__hero__logo" />
      <div class="page--home__text page--home__follow__text page--home__follow__text--call-to-action">
        <div>
          <span>Join the many curious users already</span>
          <span> signed up for early-access Beta.</span>
        </div>
        <div class="page--home__follow__text--call-to-action__bold">
          Get started today
        </div>
      </div>
      <div>
        <router-link :to="{ name: 'follow' }">
          <button class="button button--inverted page--home__hero__button page--home__hero__button--follow">
            Follow us
          </button>
        </router-link>
        <router-link :to="{ name: 'standards' }">
          <button class="button button--link page--home__hero__button page--home__hero__button--follow button--link--alternative">
            Browse Standards
          </button>
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
  margin-bottom: 2rem;
}

.page--home__hero__button--follow {
  margin-bottom: 4rem;
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
  font-weight: 600;
}
</style>
