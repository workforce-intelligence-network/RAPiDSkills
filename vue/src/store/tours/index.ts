import * as actions from './actions';
import * as mutations from './mutations';
import * as getters from './getters';

export const TOUR_ID_STANDARDS = 'standards';

export const TOUR_STEP_ID_STANDARDS_OCCUPATION_SEARCH = `${TOUR_ID_STANDARDS}-occupation-search`;
export const TOUR_STEP_ID_STANDARDS_HIGH_LEVEL_SUMMARY = `${TOUR_ID_STANDARDS}-high-level-summary`;
export const TOUR_STEP_ID_STANDARDS_FAVORITE = `${TOUR_ID_STANDARDS}-favorite`;
export const TOUR_STEP_ID_STANDARDS_DUPLICATE = `${TOUR_ID_STANDARDS}-duplicate`;
export const TOUR_STEP_ID_STANDARDS_HELP = `${TOUR_ID_STANDARDS}-help`;

export const TOUR_ID_STANDARD = 'standard';

export const TOUR_STEP_ID_STANDARD_WORK_PROCESS = `${TOUR_ID_STANDARD}-work-process`;
export const TOUR_STEP_ID_STANDARD_DUPLICATE = `${TOUR_ID_STANDARD}-duplicate`;
export const TOUR_STEP_ID_STANDARD_DOWNLOAD = `${TOUR_ID_STANDARD}-download`;
export const TOUR_STEP_ID_STANDARD_HELP = `${TOUR_ID_STANDARD}-help`;

export default {
  namespaced: true,
  state: {
    // [`${tourStepId}-visible`]: undefined // until changed
    [TOUR_ID_STANDARDS]: [
      TOUR_STEP_ID_STANDARDS_OCCUPATION_SEARCH,
      TOUR_STEP_ID_STANDARDS_HIGH_LEVEL_SUMMARY,
      TOUR_STEP_ID_STANDARDS_FAVORITE,
      TOUR_STEP_ID_STANDARDS_DUPLICATE,
      TOUR_STEP_ID_STANDARDS_HELP,
    ],
    [TOUR_STEP_ID_STANDARDS_OCCUPATION_SEARCH]: {
      id: TOUR_STEP_ID_STANDARDS_OCCUPATION_SEARCH,
      tourId: TOUR_ID_STANDARDS,
      content: 'Search by occupation to find similar work schedules to your own.',
      position: 'top-right',
    },
    [TOUR_STEP_ID_STANDARDS_HIGH_LEVEL_SUMMARY]: {
      id: TOUR_STEP_ID_STANDARDS_HIGH_LEVEL_SUMMARY,
      tourId: TOUR_ID_STANDARDS,
      content: "See a high-level summary of another program's work schedules, which organization contributed them, and how it's been used.",
      position: 'top',
    },
    [TOUR_STEP_ID_STANDARDS_FAVORITE]: {
      id: TOUR_STEP_ID_STANDARDS_FAVORITE,
      tourId: TOUR_ID_STANDARDS,
      content: "Save work schedules you're interested in coming back to review later.",
      position: 'bottom-left',
      loggedIn: true,
    },
    [TOUR_STEP_ID_STANDARDS_DUPLICATE]: {
      id: TOUR_STEP_ID_STANDARDS_DUPLICATE,
      tourId: TOUR_ID_STANDARDS,
      content: 'Copy work schedules you want to build on and customize for your needs.',
      position: 'bottom-right',
      loggedIn: true,
    },
    [TOUR_STEP_ID_STANDARDS_HELP]: {
      id: TOUR_STEP_ID_STANDARDS_HELP,
      tourId: TOUR_ID_STANDARDS,
      content: 'Need more help? See frequently asked questions in Help.',
      position: 'top-right',
    },
    [TOUR_ID_STANDARD]: [
      TOUR_STEP_ID_STANDARD_WORK_PROCESS,
      TOUR_STEP_ID_STANDARD_DUPLICATE,
      TOUR_STEP_ID_STANDARD_DOWNLOAD,
      TOUR_STEP_ID_STANDARD_HELP,
    ],
    [TOUR_STEP_ID_STANDARD_WORK_PROCESS]: {
      id: TOUR_STEP_ID_STANDARD_WORK_PROCESS,
      tourId: TOUR_ID_STANDARD,
      content: 'Expand work processes to see a full list of skills associated with it.',
      position: 'right-top',
    },
    [TOUR_STEP_ID_STANDARD_DUPLICATE]: {
      id: TOUR_STEP_ID_STANDARD_DUPLICATE,
      tourId: TOUR_ID_STANDARD,
      content: 'Want to customize this for your needs? Make a copy and get to work!',
      position: 'top-left',
      loggedIn: true,
    },
    [TOUR_STEP_ID_STANDARD_DOWNLOAD]: {
      id: TOUR_STEP_ID_STANDARD_DOWNLOAD,
      tourId: TOUR_ID_STANDARD,
      content: 'Download the original source for this work schedule.',
      position: 'top-left',
      loggedIn: true,
    },
    [TOUR_STEP_ID_STANDARD_HELP]: {
      id: TOUR_STEP_ID_STANDARD_HELP,
      tourId: TOUR_ID_STANDARD,
      content: 'Need more help? See frequently asked questions in Help.',
      position: 'top-right',
    },
  },
  mutations,
  actions,
  getters,
};
