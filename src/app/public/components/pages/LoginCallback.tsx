// Library Imports
import * as React from 'react';

// App Imports
import Auth from '@app/public/Auth';

interface LoginCallbackProps {
  location: Location;
}

export default class LoginCallback extends React.Component<LoginCallbackProps> {
  public componentDidMount() {
    if (/access_token|id_token|error/.test(this.props.location.hash)) {
      Auth.handleAuthentication();
    }
  }

  public render(): React.ReactElement<any> {
    return null;
  }
}
