import * as actions from './actions';
import * as mutations from './mutations';
import * as getters from './getters';

export const TOUR_ID_STANDARDS = 'standards';
export const TOUR_ID_STANDARD = 'standard';

export const TOUR_STEP_ID_STANDARDS_OCCUPATION_SEARCH = 'occupation-search';
export const TOUR_STEP_ID_STANDARDS_HIGH_LEVEL_SUMMARY = 'high-level-summary';
export const TOUR_STEP_ID_STANDARDS_FAVORITE = 'favorite';
export const TOUR_STEP_ID_STANDARDS_DUPLICATE = 'duplicate';

export default {
  namespaced: true,
  state: {
    // [`${tourStepId}-visible`]: undefined // until changed
    [TOUR_ID_STANDARDS]: [
      TOUR_STEP_ID_STANDARDS_OCCUPATION_SEARCH,
      TOUR_STEP_ID_STANDARDS_HIGH_LEVEL_SUMMARY,
      TOUR_STEP_ID_STANDARDS_FAVORITE,
      TOUR_STEP_ID_STANDARDS_DUPLICATE,
    ],
    [TOUR_STEP_ID_STANDARDS_OCCUPATION_SEARCH]: {
      id: TOUR_STEP_ID_STANDARDS_OCCUPATION_SEARCH,
      tourId: TOUR_ID_STANDARDS,
      content: 'Search by occupation to find similar standards to your own.',
      // title: '',
      // content: '',
      // skipText: '',
      // closeText: '',
      // position: 'top-left',
    },
    [TOUR_STEP_ID_STANDARDS_HIGH_LEVEL_SUMMARY]: {
      id: TOUR_STEP_ID_STANDARDS_HIGH_LEVEL_SUMMARY,
      tourId: TOUR_ID_STANDARDS,
      content: "See a high-level summary of another program's standards, which organization contributed them, and how it's been used.",
    },
    [TOUR_STEP_ID_STANDARDS_FAVORITE]: {
      id: TOUR_STEP_ID_STANDARDS_FAVORITE,
      tourId: TOUR_ID_STANDARDS,
      content: "Save standards you're interested in coming back to review later. You'll need to create an account.",
    },
    [TOUR_STEP_ID_STANDARDS_DUPLICATE]: {
      id: TOUR_STEP_ID_STANDARDS_DUPLICATE,
      tourId: TOUR_ID_STANDARDS,
      content: "Copy standards you want to build on and customize for your needs. You'll need to create an account.",
    },
    [TOUR_ID_STANDARD]: [

    ],
  },
  mutations,
  actions,
  getters,
};
