<template>
  <div>
    <div
      id="customer_table_div"
      v-if="variables.customer_info_fetch_error_message.length === 0"
    >
      <input
        type="text"
        v-model="variables.search_box_input"
        placeholder="Search Anything Here"
      />
      <table>
        <tr>
          <th style="width: 30%">
            ID
            <!-- general sort icon is displayed here -->
            <!--
          when it is clicked it sets sort by id to 1 (Ascending), sort by name to 0 (Not sort by name).
          So it sorts the list by id in ascending order
          -->
            <font-awesome-icon
              class="icon"
              icon="fa-sort"
              size="1x"
              v-if="variables.sort.id === 0"
              @click="
                variables.sort.id = 1;
                variables.sort.name = 0;
              "
            />

            <!--sort ascending icon is displayed here-->
            <!--
           when it is clicked it sets sort by id to 2 (Descending), sort by name to 0 (Not sort by name).
           So it sorts the list by id in descending order
           -->
            <font-awesome-icon
              icon="fa-sort-up"
              class="icon"
              size="1x"
              v-if="variables.sort.id === 1"
              @click="
                variables.sort.id = 2;
                variables.sort.name = 0;
              "
            />
            <!--sort descending icon is displayed here-->
            <!--
         when it is clicked it sets sort by id to 0 (Not sort by id), sort by name to 0 (Not sort by name).
         So it is showing original order when the list was fetched
         -->
            <font-awesome-icon
              icon="fa-sort-down"
              class="icon"
              size="1x"
              v-if="variables.sort.id === 2"
              @click="
                variables.sort.id = 0;
                variables.sort.name = 0;
              "
            />
          </th>
          <th style="width: 70%">
            Full Name
            <!-- general sort icon is displayed here -->
            <!--
          when it is clicked it sets sort by name to 1 (Ascending), sort by id to 0 (Not sort by id).
          So it sorts the list by name in ascending order
          -->
            <font-awesome-icon
              icon="fa-sort"
              size="1x"
              class="icon"
              v-if="variables.sort.name === 0"
              @click="
                variables.sort.name = 1;
                variables.sort.id = 0;
              "
            />
            <!--sort ascending icon is displayed here-->
            <!--
           when it is clicked it sets sort by name to 2 (Descending), sort by id to 0 (Not sort by id).
           So it sorts the list by name in descending order
           -->
            <font-awesome-icon
              icon="fa-sort-up"
              class="icon"
              size="1x"
              v-if="variables.sort.name === 1"
              @click="
                variables.sort.name = 2;
                variables.sort.id = 0;
              "
            />
            <!--sort descending icon is displayed here-->
            <!--
         when it is clicked it sets sort by id to 0 (Not sort by id), sort by name to 0 (Not sort by name).
         So it is showing original order when the list was fetched
         -->
            <font-awesome-icon
              icon="fa-sort-down"
              class="icon"
              size="1x"
              v-if="variables.sort.name === 2"
              @click="
                variables.sort.name = 0;
                variables.sort.id = 0;
              "
            />
          </th>
        </tr>
        <tr
          :key="`tr_customer_info_${index}`"
          v-for="(customer_info, index) in compute_customer_info_list()"
        >
          <td>
            {{ customer_info.id }}
          </td>
          <td>
            <font-awesome-icon
              icon="fa-user"
              size="1x"
              class="icon"
              @click="variables.current_user_details = customer_info"
            />
            {{ customer_info.first_name }} {{ customer_info.last_name }}
          </td>
        </tr>
      </table>
      <h3>
        Click
        <font-awesome-icon icon="fa-sort" size="1x" />
        to sort the order
      </h3>
      <h3>
        Click
        <font-awesome-icon icon="fa-user" size="1x" />
        to see customer details
      </h3>
    </div>
    <div id="error_msg" v-else>
      <h4>Error Occurred When Fetching Customers Information From API</h4>
      <ul>
        <li
          :key="`li${index}`"
          v-for="(
            each_err_msg, index
          ) in variables.customer_info_fetch_error_message"
        >
          {{ each_err_msg }}
        </li>
      </ul>
      <button @click="fetch_all_customers_info">
        Click me to refresh the list
      </button>
    </div>
  </div>

  <model-panel
    v-if="variables.current_user_details"
    :close_window="close_model"
  >
    <template #content>
      <table id="customer_detail_table">
        <tr>
          <td>
            <img
              :src="variables.current_user_details.avatar"
              alt="Girl in a jacket"
              width="100"
              height="100"
            />
          </td>
          <td>
            <p>ID: <span v-html="variables.current_user_details.id" /></p>
            <p>Email: <span v-html="variables.current_user_details.email" /></p>
            <p>
              First Name:
              <span v-html="variables.current_user_details.first_name" />
            </p>
            <p>
              Last Name:
              <span v-html="variables.current_user_details.last_name" />
            </p>
          </td>
        </tr>
      </table>
    </template>
  </model-panel>
</template>
<script setup lang="ts">
import { onBeforeMount, ref } from "vue";
import axios, { AxiosError, type AxiosResponse } from "axios";
import ModelPanel from "@/components/ModelPanel.vue";
import { library } from "@fortawesome/fontawesome-svg-core";
import {
  faSort,
  faSortDown,
  faSortUp,
  faUser,
} from "@fortawesome/free-solid-svg-icons";
import {
  start_loading_spinner,
  stop_loading_spinner,
} from "@/functions/Function";

/*** add icons to fontawesome library  ***/
library.add(faUser, faSort, faSortUp, faSortDown);

interface CustomerInfoType {
  id: number;
  email: string;
  first_name: string;
  last_name: string;
  avatar: string;
}

interface CustomerInfoApiResponseType {
  page: number;
  per_page: number;
  total: number;
  total_pages: number;
  data: CustomerInfoType[];
  support: {
    url: string;
    text: string;
  };
}

/*** All variables used in the component ***/
const variables = ref<{
  search_box_input: string;
  customer_info_list: CustomerInfoType[];
  customer_info_fetch_error_message: string[];
  current_user_details: CustomerInfoType | null;
  sort: {
    /**** 0 no sorting, 1 ascending, 2 descending ****/
    id: 0 | 1 | 2;
    name: 0 | 1 | 2;
  };
}>({
  search_box_input: "",
  customer_info_list: [],
  customer_info_fetch_error_message: ["sdfsdf"],
  current_user_details: null,
  sort: {
    id: 0,
    name: 0,
  },
});

/****
 * Compute customer info including sorting and filtering functions
 * @input no input
 * @output filtered,sorted customer info list
 * ***/
function compute_customer_info_list(): CustomerInfoType[] | null {
  /*** If it has errors then return nothing ***/
  if (variables.value.customer_info_fetch_error_message.length > 0) return [];
  /*** Filter the list to include customers info that has values inserted in search box ***/
  let filtered_customer_list = variables.value.customer_info_list.filter(
    (each_customer_info) => customer_info_is_needed(each_customer_info)
  );

  /*** Sort and return list****/
  return sort_customer_info_list(filtered_customer_list);
}

/*** set variables.value.current_user_details to null so that the modal component is destroyed
 * @input no input
 * @output no return from the function but it sets current_user_details to null ***/
function close_model() {
  variables.value.current_user_details = null;
}

/*** Use Axios to fetch customer list
 * @input which page of customer list to fetch
 * @output return fetched items, if it has errors then err msg is added to variables.value.customer_info_fetch_error_message  ***/
async function use_customer_information_list_api(
  page_number: number
): Promise<CustomerInfoApiResponseType> {
  let api_response_data: CustomerInfoApiResponseType = {
    page: 0,
    per_page: 0,
    total: 0,
    total_pages: -99,
    data: [],
    support: {
      url: "",
      text: "",
    },
  };

  await axios
    .get(`https://reqres.in/api/users?page=${page_number}`)
    .then((response: AxiosResponse) => {
      /**** Make sure the received object is not empty ****/
      const received_obj_keys = Object.keys(response.data);
      if (received_obj_keys.length === 0)
        variables.value.customer_info_fetch_error_message.push(
          "Oops! The API did not return correct information. Please try again later."
        );
      else {
        /**** Make sure total_pages, data keys are in the received object ****/
        ["total_pages", "data"].filter((each_required_key) => {
          if (received_obj_keys.indexOf(each_required_key) === -1) {
            variables.value.customer_info_fetch_error_message.push(
              "Oops! The API did not return correct information. Please try again later."
            );
          }
        });
      }
      /*** Make sure none of the checks above has errors ***/
      if (variables.value.customer_info_fetch_error_message.length === 0)
        api_response_data = response.data as CustomerInfoApiResponseType;
    })
    .catch((error: AxiosError) => {
      variables.value.customer_info_fetch_error_message.push(
        "Unexpected Error!"
      );
      /*** check if it is axios error if yes tell user the error code ***/
      if (error.response) {
        if (error.response.status) {
          variables.value.customer_info_fetch_error_message.push(
            `Error Code: ${error.response.status}`
          );
        }
      }
    });
  return api_response_data;
}

/****
 * get/process all customers info from all pages and push all to variables.value.customer_info_list
 * @input no input
 * @output no output from the function but all customers info are added to customer_info_list
 * ***/
async function fetch_all_customers_info() {
  /*** Clear error message and customer_info_list because user can refresh the list if there was an fetch error during mounting ***/
  variables.value.customer_info_fetch_error_message = [];
  variables.value.customer_info_list = [];

  /*** Fetch customer info list from the API ***/
  let current_page_number = 1;
  // console.log(current_page_number);
  /*** Tell user that I am busy ***/
  start_loading_spinner();

  /**** while loop the api until all pages are fetched
   * current_page_number value becomes -99 when
   * - all pages are fetched
   * - fetch API has errors
   * ****/
  while (current_page_number !== -99) {
    const customer_information_response =
      await use_customer_information_list_api(current_page_number);
    if (variables.value.customer_info_fetch_error_message.length === 0) {
      /*** Push customer info from current page to customer_info_list***/
      variables.value.customer_info_list.push(
        ...customer_information_response.data
      );
      if (current_page_number >= customer_information_response.total_pages) {
        current_page_number = -99;
      } else current_page_number++;
    } else {
      current_page_number = -99;
    }
  }
  stop_loading_spinner();
}

/***
 * Sort the customer list by using variables.value.sort id and name both variables
 * 0 no sorting
 * 1 Ascending
 * 2 Descending
 *  more details can be found in font-awesome-icon type tags in DOM
 *  ie. <font-awesome-icon
 *               class="icon"
 *               icon="fa-sort"
 *               size="1x"
 *               v-if="variables.sort.id === 0"
 *               @click="
 *                 variables.sort.id = 1;
 *                 variables.sort.name = 0;
 *               "
 *             />
 * ***/
function sort_customer_info_list(customer_info_list: CustomerInfoType[]) {
  /*** set sort by and sort type both variable in order to for both id/name to use in sort_customers ***/
  let sort_by: keyof CustomerInfoType = "id",
    sort_type = 0;

  if (variables.value.sort.id > 0) {
    /*** user clicks sort by id ***/
    sort_by = "id";
    sort_type = variables.value.sort.id;
  } else if (variables.value.sort.name > 0) {
    /*** user clicks sort by name ***/
    sort_by = "first_name";
    sort_type = variables.value.sort.name;
  } else {
    /**** sort_type is 0, return original customer_info_list if no sorting is not needed ****/
    return customer_info_list;
  }

  function sort_customers(
    customer_a: CustomerInfoType,
    customer_b: CustomerInfoType
  ) {
    if (customer_a[sort_by] > customer_b[sort_by]) {
      /***
       * Example Case: Rachel(customer_a) > George(customer_b)
       * sort_type is 0 then it does not trigger this (sort_customers) function at the first place
       * sort_type is 1 (Ascending) then it should return 1 (R is greater than G, so George and Rachel should swap so return 1)
       * sort_type is 2 (Descending) then it should return -1 (R is greater than G, but we need descending order so -1 mean it does not need swap)
       * ***/
      // console.log(
      //   `${customer_a[sort_by]} >${customer_b[sort_by]}`,
      //   sort_type === 1 ? 1 : -1
      // );
      return sort_type === 1 ? 1 : -1;
    } else if (customer_a[sort_by] < customer_b[sort_by]) {
      /***
       * Example Case: 5 Rachel(customer_a) < 10 Tracey (customer_b)
       * sort_type is 0 then it does not trigger this (sort_customers) function at the first place
       * sort_type is 1 (Ascending) then it should return -1 (R is less than G which is in right order so return -1 , no need to swap)
       * sort_type is 2 (Descending) then it should return 1 (R is less than G which is true but we want the order the other way round so it needs to swap again)
       * ***/

      // console.log(
      //   `${customer_a[sort_by]} <${customer_b[sort_by]}`,
      //   sort_type === 1 ? -1 : 1
      // );
      return sort_type === 1 ? -1 : 1;
    } else {
      // console.log(customer_a[sort_by], customer_b[sort_by]);
      /**** no need to do anything because the name is same  ****/
      return 0;
    }
    /*** i.e Tobias <Tracey because of first character is the same so it compares second characters***/
  }

  return customer_info_list.slice().sort(sort_customers);
}

/****
 * check if current customer info obj has the value that includes search box value
 * @input current_customer_info
 * @output boolean, true - it has the search box value, false - it does not have the search box value
 * ***/
function customer_info_is_needed(current_customer_info: CustomerInfoType) {
  let current_customer_info_is_needed = false;

  /*** loop though all values from current customer info obj ***/
  Object.values(current_customer_info).filter((each_value: string | number) => {
    /*** only process string or number type values and ignore null/undefined ***/
    if (["string", "number"].indexOf(typeof each_value) > -1) {
      /**** make current value and search key both lower case ****/
      const current_value_includes_search_box_value = String(each_value)
        .toLowerCase()
        .includes(variables.value.search_box_input.toLowerCase());
      if (current_value_includes_search_box_value)
        current_customer_info_is_needed = true;
    }
  });
  return current_customer_info_is_needed;
}

/*** fetch all customers info before DOM is created ***/
onBeforeMount(async () => {
  await fetch_all_customers_info();
});
</script>
<style scoped lang="scss">
#customer_table_div {
  text-align: center;

  table,
  input {
    width: 50%;
    margin: 1% auto;
  }

  th,
  td {
    text-align: unset;
    border: 1px solid black;
  }
}

#error_msg {
  //text-align: center;
  margin: auto 20%;
  * {
    color: red;
  }
}

#customer_detail_table {
  margin: 5% auto;
}
</style>
