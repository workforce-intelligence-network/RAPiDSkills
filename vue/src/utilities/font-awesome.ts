import Vue from 'vue';

import { library } from '@fortawesome/fontawesome-svg-core';
import {
  faBolt, faCaretDown, faCaretUp, faCaretLeft, faCaretRight,
} from '@fortawesome/free-solid-svg-icons';
import { faFacebookF, faTwitter } from '@fortawesome/free-brands-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

library.add(faBolt);
library.add(faFacebookF);
library.add(faTwitter);
library.add(faCaretRight);
library.add(faCaretUp);
library.add(faCaretDown);
library.add(faCaretLeft);

Vue.component('FontAwesomeIcon', FontAwesomeIcon);
