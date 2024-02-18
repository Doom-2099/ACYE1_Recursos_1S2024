import { useState } from "react";
import { Login } from "./components/Login";
import { Principal } from "./components/Principal";

function App() {
  const [loginState, setLoginState] = useState(false);

  const updateState = (value) => {
    setLoginState(value);
  };

  return (
    <>
      {!loginState && <Login setContent={updateState} />}

      {loginState && <Principal setContent={updateState} />}
    </>
  );
}

export default App;
