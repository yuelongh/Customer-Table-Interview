/*** to make loading spinner appear/disappear. it is mainly used for axios ***/
export function start_loading_spinner() {
  document.body.classList.add("loading_spinner");
}

export function stop_loading_spinner() {
  document.body.classList.remove("loading_spinner");
}
