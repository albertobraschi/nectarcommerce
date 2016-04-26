import Constants from '../constants';
import {httpGet} from '../utils';


const Actions = {
  fetchCurrentCartSummary: () => {
    return dispatch => {
      dispatch({type: Constants.FETCHING_CART_SUMMARY});

      httpGet('/cart?summary=true')
      .then((data) => {
        dispatch({
          type: Constants.CART_SUMMARY_RECEIVED,
          cart_summary: data
        });
      });
    };
  }
};

export default Actions;
