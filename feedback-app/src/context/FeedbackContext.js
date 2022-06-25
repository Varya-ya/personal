import { createContext, useState } from 'react';
import { v4 as uuidv4 } from 'uuid';

const FeedbackContext = createContext();

export const FeedbackProvider = ({ children }) => {
    const [feedback, setFeedback] = useState([
        {
            id: 1,
            text: 'This item is number 1',
            rating: 10,
        },
        {
            id: 2,
            text: 'This item is number 2',
            rating: 6,
        },
        {
            id: 3,
            text: 'This item is number 3',
            rating: 5,
        }
    ]);

    const [feedbackEdit, setFeedbackEdit] = useState({
        item: {},
        edit: false,
    }); 

    const deleteFeedback = (id) => {
        setFeedback(feedback.filter((item) => item.id !== id))
    };

    const addFeedback = (newFeedback) => {
        newFeedback.id = uuidv4()
        setFeedback([newFeedback, ...feedback])
    };

    const editFeedback = (item) => {
        setFeedbackEdit({
            item, 
            edit: true
        })
    }

    return <FeedbackContext.Provider value={{
        feedback,
        deleteFeedback,
        addFeedback,
        editFeedback,
        feedbackEdit
    }}>
        {children}
    </FeedbackContext.Provider>
}

export default FeedbackContext