import React from 'react';
import { ButtonGroup, Row, Button } from 'react-bootstrap';

const TagListView = tags => {
    if(tags.tags) {
        return(
            <ButtonGroup as={Row}>
                {tags.tags.map(tag => {  
                    return (
                    <Button value={tag.color} style={{backgroundColor: tag.color}} name={tag.tid} data-testid={tag.name}>
                        {tag.name}
                    </Button>
                    )
                })}
            </ButtonGroup>
        )
    } else {
        return(<> </>);
    }
};

export default TagListView;