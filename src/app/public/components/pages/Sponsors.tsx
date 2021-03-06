// Library Imports
import axios from 'axios';
import * as Promise from 'bluebird';
import * as _ from 'lodash';
import * as React from 'react';
import { Card, Container, Image, Segment } from 'semantic-ui-react';

interface SponsorsProps {
  loading: (status: boolean) => any;
}

interface SponsorsState {
  sponsors: Sponsor[];
}

export default class Sponsors extends React.Component<SponsorsProps, SponsorsState> {
  constructor(props: SponsorsProps) {
    super(props);

    this.state = { sponsors: [] };
  }

  public componentDidMount() {
    Promise.resolve(() => this.props.loading(true))
      .then(() => axios.get('/api/public/sponsors'))
      .then(res => {
        this.props.loading(false);
        this.setState({ sponsors: res.data.data });
      });
  }

  public render() {
    return (
      <Segment style={{ padding: '4em 0em' }} vertical>
        <Container>
          <Card.Group>
            {_.map(_.sortBy(this.state.sponsors, ['priority']), sponsor => (
              <Card key={sponsor.name}>
                <Image src={`http://volunteeringpeel.org/${sponsor.image}`} />
                <Card.Content>
                  <Card.Header>{sponsor.name}</Card.Header>
                </Card.Content>
                <Card.Content extra>
                  <Card.Meta>
                    <a href={sponsor.website}>Website</a>
                  </Card.Meta>
                </Card.Content>
              </Card>
            ))}
          </Card.Group>
        </Container>
      </Segment>
    );
  }
}
