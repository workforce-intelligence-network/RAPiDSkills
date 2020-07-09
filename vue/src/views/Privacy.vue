<template>
  <div class="page--privacy">
    <div class="page--privacy__title">
      Privacy Policy
    </div>
    <div class="page--privacy__policy">
      <h5>Last Updated 4/24/2020</h5>

      <p>WIN (also referred to as “we,” or “us,” or “our”) is committed to protecting your information. This Privacy Policy explains how we collect, use, retain, and share your information, and the choices that are available to you when using RapidSkills Generator (the terms you or your, also include your organization or company). This Privacy Policy is incorporated into our <router-link to="terms">Terms of Use</router-link>, which also apply when you use RapidSkills Generator.</p>
      <p>By using RapidSkills Generator, you agree to our handling of your User Information in accordance with this Privacy Policy. If you do not agree to the terms of this Privacy Policy, do not use RapidSkills Generator or otherwise provide any User Information, including Personal Information or Sample Information.</p>
      <h3>Information We Collect</h3>
      <h4>User Information</h4>
      <p>We collect and store User Information that you provide when using RapidSkills Generator. User Information is information that identifies you and how you use RapidSkills Generator. You can perform certain activities on RapidSkills Generator, including searching for apprenticeship program samples, without providing any User Information. However, to use certain features of RapidSkills Generator, such as to customize a sample work process or to sign up to receive email updates, we will ask you to provide certain Personal Information. Your use of certain features of RapidSkills Generator will provide us with Sample Information.</p>

      <h4>Personal Information</h4>
      <p>Personal information may include your name, email address, and other such information Personal Information does not include anonymized, aggregated or statistical information from which your identity could be deduced. We do not include IP addresses as Personal information, and we do not retain, use, or disclose your IP address after your using RapidSkills Generator.</p>

      <h4>Sample Information</h4>
      <p>Sample Information is information that you provide when customizing an apprenticeship program. Sample information may include industry identifiers, occupation identifiers, competencies, skills, and tasks. Sample information may be combined with Personal Information you provide.</p>
      <h3>How We Use Information We Collect</h3>
      <p>We use User Information we collect for various purposes, including to:</p>
      <ol>
        <li>Improve RapidSkills Generator and its features;</li>
        <li>Improve WIN’s products and services, including developing its partnerships, and to identify, develop and offer new or expanded products and services;</li>
        <li>Provide you with relevant updates;</li>
        <li>To send you additional relevant information about the products and services that we offer;</li>
        <li>Respond to your questions, comments, feedback, or inquiries;</li>
        <li>Compile Sample Information for research and analytical purposes; and</li>
        <li>To manage RapidSkills Generator, such as for monitoring activity, enforcing our Terms and Privacy Policy, or to comply with authorities under applicable laws and regulations.</li>
      </ol>
      <h3>How We Share Information We Collect</h3>
      <p>We may share User Information for only these purposes:</p>
      <ol>
        <li>To entities with whom we partner and/or who provide services to us, including organizations or companies that provide application analytics, data processing and management, and other data and information technology services such as application development, maintenance, web services, and other services;</li>
        <li>To establish or exercise our legal rights, or to defend against Claims;</li>
        <li>With an organization or company that we transfer RapidSkills Generator to in the event that we ever transfer the ongoing operation and management of RapidSkills Generator; and</li>
        <li>With your consent.</li>
      </ol>

      <p>We may share Sample Information for various research and development purposes. This Sample information is shared without corresponding User Information, so that it does not identify you or your organization or company as the provider of the apprenticeship program information. We may share Sample Information with the following:</p>
      <ol>
        <li>Researchers, such as social scientists, economists, and analysts, and their employing organizations;</li>
        <li>Federal and state departments of labor;</li>
        <li>Local workforce development systems, including apprenticeship intermediaries;</li>
        <li>College systems, including community colleges;</li>
        <li>Organizations that supply labor market information at any geographic level or for any geographic location; and</li>
        <li>The developers of competency frameworks and similar skill outlines.</li>
      </ol>

      <p>When we share Sample Information we enter into an agreement with the receiver of the Sample Information.</p>
      <h3>Your Ability to Opt Out of Our Use of Your Information</h3>
      <p>When you provide your email address on RapidSkills Generator, you agree to receiving relevant updates and information from us. You have the ability to opt out of receiving our emails at any time by emailing us at <a href="mailto:info@rapidskillsgenerator.org">info@rapidskillsgenerator.org</a>, or by clicking “unsubscribe” on any email that you receive. Additionally, we retain and use the information we collect from and about you on RapidSkills Generator for as long as it is necessary to achieve the purposes for which the information was collected, unless otherwise prohibited by the appropriate legal authorities. Users of RapidSkills Generator who have created an account in order to access certain features of RapidSkills Generator are able to access and manage that profile to ensure that it is accurate and up-to-date, to make changes, or to change their username and password.</p>
      <h3>Security of Your Personal Information</h3>
      <p>We have implemented commercially reasonable security measures to help prevent loss of, unauthorized access to, or misuse of your User Information. However, no method of internet security is completely impenetrable or error free; hence we cannot guarantee that your information or that of your organization or company will never be disclosed in a manner inconsistent with this Privacy Statement (for example, as a result of unauthorized acts, such as hacking, by third parties that violate applicable laws).</p>
      <h3>Governing Law and Jurisdiction/Shortening Limitations Period/Jury Waiver</h3>
      <p>You agree that any Claims arising out of or relating to these Terms or the Privacy Policy shall be governed by and construed in accordance with the laws of the United States and the State of Michigan, without regard to conflict of laws. All Claims will be resolved exclusively in the state or federal courts located in the State of Michigan and you consent to the jurisdiction of those courts. All Claims must be filed in a court of competent jurisdiction within six (6) months of the event or events giving rise to the Claims, or they are forever barred.  All Claims will be decided by a judge; a jury is waived for all Claims.  Prior to or promptly upon the filing of any Claims, all parties must participate in good faith in non-binding mediation in an effort to resolve the Claims.  The parties shall jointly share the cost of mediation, but are responsible for their own respective costs and attorney fees.  You affirm that you have the authority to bind yourself, and your organization or company to these Terms and the Privacy Policy.  If any portion of these Terms or the Privacy Policy are deemed invalid or unenforceable by any court of competent jurisdiction, all other portions of these Terms and Privacy Policy shall nonetheless be enforced.</p>
      <h3>Changes to This Privacy Statement</h3>
      <p>We reserve the right to change this Privacy Policy, or any portion thereof, at our sole discretion, at any time and without prior notice to you, as a response to new laws, regulations, technology and security standards, or for any other business reasons. You can determine when the Privacy Policy was last updated by referring to the “Last Updated” notation above. Your continued use of RapidSkills Generator following any changes confirms your acceptance of the Privacy Policy as revised.</p>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import {
  Component,
} from 'vue-property-decorator';

@Component
export default class Privacy extends Vue {
}
</script>

<style scoped lang="scss">
@import "@/scss/page";
@import "@/scss/colors";

.page--privacy {
  padding-top: 2rem;
  max-width: 50rem;
  margin: 0 auto;
}

.page--privacy__title {
  color: $color-black;
  font-weight: 500;
  font-size: 1.75rem;
  margin-bottom: 2rem;
}

.page--privacy__policy {
  font-size: 1rem;
  line-height: 2rem;
  text-align: left;
  font-family: "Lora", serif;
}
</style>
