import { createContext, useState, useEffect } from 'react';

const FeedbackContext = createContext();

export const FeedbackProvider = ({ children }) => {
    const [isLoading, setIsLoading] = useState(true);
    const [feedback, setFeedback] = useState([]);

    const [feedbackEdit, setFeedbackEdit] = useState({
        item: {},
        edit: false,
    }); 

    useEffect(() => {
        fetchFeedback()
    }, []);

    const fetchFeedback = async () => {
        const response = await fetch(`http://localhost:5000/feedback?_sort=is&_order=desc`)
        const data = await response.json()

        setFeedback(data)
        setIsLoading(false)
    };

    const deleteFeedback = (id) => {
        setFeedback(feedback.filter((item) => item.id !== id))
    };

    const addFeedback = (newFeedback) => {
        setFeedback([newFeedback, ...feedback])
    };

    const updateFeedback = (id, updItem) => {
        setFeedback(feedback.map((item) => item.id === id ? { ...item, ...updItem } : item))

        setFeedbackEdit({
            item: {},
            edit: false,
        })
    };

    const editFeedback = (item) => {
        setFeedbackEdit({
            item,
            edit: true
        })
    };

    return <FeedbackContext.Provider value={{
        feedback,
        deleteFeedback,
        addFeedback,
        editFeedback,
        feedbackEdit, 
        updateFeedback, 
        isLoading
    }}>
        {children}
    </FeedbackContext.Provider>
}

export default FeedbackContext