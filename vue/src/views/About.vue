<template>
  <div class="page page--about">
    <div class="page--about__title">
      About Us
    </div>
    <div class="page--about__description">
      <p>In 2015, the Southeast Michigan Community Alliance (SEMCA) and the Workforce Intelligence Network (WIN) partnership of nine community colleges and six workforce development boards in Michigan were awarded the US Department of Labor American Apprenticeship Initiative (AAI) grant which provided funding to develop the Advance Michigan Center for Apprenticeship Innovation (AMCAI). An AMCAI hub was created on <a href="https://www.miapprenticeship.org">www.miapprenticeship.org</a> with resources including a Return on Investment (ROI) calculator for over 52 in-demand occupations, an Apprenticeship Process Guide, and best practices to establish Registered Apprenticeship in a Day (RAPiD) workshop events which conclude with a DOL signing of standards ceremony. These best practices largely contributed to the AMCAI team becoming recognized as one of the Top 15 AAI grantees in the nation in January 2020.</p>
      <p>One of the final AMCAI deliverables under the AAI grant was to develop the RapidSkills Generator which is an open source, online repository of time-based and competency-based occupational frameworks for registered apprenticeship programs.</p>
      <h3>Background</h3>
      <p>WIN is seeking to cultivate a strong apprenticeship ecosystem by making it easier for employers to create customized time-based, competency-based, and hybrid apprenticeship programs.</p>
      <p>Competency-based training places a focus on skills and helps instructors and learners track progress through an apprenticeship program. Many employers and workers understand the competencies that are required for an occupation, but do not document competencies in a way that facilitates learning, updating, and sustaining key job skills. Another challenge is the lack of understanding by workforce development professionals and educational institutions on how to generate a competency-based apprenticeship program for employers.</p>
      <p>The process of developing a competency-based apprenticeship program can be time-consuming and difficult to achieve. Employers and workforce development professionals are often duplicating efforts when they create competency-based apprenticeship programs. While a few organizations have posted their competency-based program outlines, there is no repository of easy-to-access competency-based program samples or skills outlines.</p>
      <p>The RapidSkills Generator system builds on a competency-based language that has already been vetted by industry and education partners.</p>
      <p>RapidSkills Generator is accessible to all. It allows individuals building apprenticeship programs to draw from a wide variety of sample skills outlines that can be customized to create competency-based work process outlines for apprenticeship programs.</p>
      <h3>System Goals:</h3>
      <ul>
        <li>Provide an efficient method of developing (time-based, competency-based, or hybrid) apprenticeship programs</li>
        <li>Share high quality skills outlines and competency-based work process outlines with a wide audience</li>
        <li>Continuously improve skills outlines for apprenticeable occupations</li>
        <li>Obtain information about in-demand skills through a high volume of users creating customized skill outlines</li>
        <li>Improve the alignment of workforce development and educational offerings in response to technological advancements and changing labor market demands</li>
      </ul>
      <h3>National resource for US DOL Apprenticeship: Closing the skills gap grantees</h3>
      <p>In February 2020, the U.S. Department of Labor announced grant awards to 28 public-private apprenticeship partnerships totaling nearly $100 million through the Apprenticeship: Closing the Skills Gap grant program which is a 48-month program beginning March 1, 2020. Due to COVID-19, a period of performance extension may be issued which could alter the four-year grant period. These grants will support large-scale expansion of apprenticeship in industries including advanced manufacturing, healthcare and information technology.</p>
      <p>There are more than 6.4 million job openings <a href="https://www.bls.gov/news.release/jolts.nr0.htm">reported in the United States</a> and expanding apprenticeships will help individuals gain the skills necessary to fill these vacancies.</p>
      <p>"These grants will further the efforts to expand apprenticeships. For Americans who want an alternative to the traditional bachelor's degree, apprenticeships are a way to learn valuable skills that lead to good paying careers," said U.S. Secretary of Labor Eugene Scalia. "Companies across the country say that their greatest challenge today is finding the skilled workers they need. This funding will bolster America's competitiveness by adding more skilled workers to fill millions of open jobs today and in the future." Secretary Scalia made the announcement during a trip to North Carolina State University, one of the grantees.</p>
      <p>The Apprenticeship: Closing the Skills Gap grant program will support the training of more than 92,000 individuals in new or expanded apprenticeship programs for a range of employers. The grantees include: Aerospace Machinist Joint Training Committee in WA; AFL-CIO Working for America in DC; Alamo Community College District in TX; American Association of Port Authorities in VA; Argentum in VA; Arkansas Division of Higher Education in AR; Arizona Board of Regents, on behalf of Arizona State University in AZ; Colorado Community College System in CO; Electrical Training ALLIANCE in MD; Florida Alcohol and Drug Abuse Association in FL; Goodwin College Inc. in CT; H-CAP Inc. in NY; Idaho State Board of Education in ID; Ivy Tech Community College of Indiana in IN; Missouri Chamber Foundation in MO; North Carolina State University in NC; Oakland Community College in MI; Office of Postsecondary Commissioner, State of Rhode Island in RI; Regents of the University of Colorado/UOC-Colorado Springs in CO; SHRM Foundation Inc. in VA; Southern Utah University in UT; Southwest Tennessee Community College in TN; The Regents of the University of California (Davis) in CA; The Regents of the University of California (Riverside) in CA; University of Louisville Research Foundation Inc. in KY; University of Wisconsin-Whitewater in WI; Wireless Infrastructure Association in VA; and, Wisconsin Regional Training Partnership Inc. in WI.</p>
      <p>RapidSkills Generator is a resource for any organization involved with developing apprenticeship programs. The AMCAI team looks forward to working collaboratively over the next four years with all DOL Closing the Skills Gap grantees through the use of the RapidSkills Generator.</p>
      <p>Sincerely,</p>
      <p>Michele Economou Ureste</p>
      <div>
        <img :src="SIGNATURE_MICHELE" alt="Michele's Signature" />
      </div>
      <p>Executive Director</p>
      <p>Workforce Intelligence Network</p>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import {
  Component,
  Provide,
} from 'vue-property-decorator';

import SIGNATURE_MICHELE from '@/assets/signature.png';

@Component
export default class about extends Vue {
  @Provide('SIGNATURE_MICHELE') SIGNATURE_MICHELE = SIGNATURE_MICHELE
}
</script>

<style scoped lang="scss">
@import "@/scss/page";
@import "@/scss/colors";

.page--about {
  max-width: 50rem;
  margin: 0 auto;
}

.page--about__title {
  color: $color-black;
  font-weight: 500;
  font-size: 1.75rem;
  margin-bottom: 2rem;
}

.page--about__description {
  font-size: 1rem;
  line-height: 2rem;
  text-align: left;
  font-family: "Lora", serif;
}
</style>
