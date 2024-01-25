//higher order function
//a function that recevies another fn as argument adn return a function
//()=>{()=>{}}
//()=>()=>{}

const asyncHandler = (requestHandler) => {
  return (req, res, next) => {
    Promise.resolve(requestHandler(req, res, next)).catch((error) =>
      next(error)
    );
  };
};

export { asyncHandler };
