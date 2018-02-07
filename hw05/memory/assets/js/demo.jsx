import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_demo(root, channel) {
  ReactDOM.render(<Game channel={channel}/>, root);
}

// App state for Memory is:
// {
//     letters: Char Array,   // letter A-H
//     lastClicked: int,      // keep track of the index of last
//                            // clicked letter in the array
//     isDisabled: boolean,   // once a tile is clicked, all tile
//                            // button is disabled for 1s
//     isClicked: boolean Array, // the tile being clicked is set to true
//                               // used to change its ccs class
//     corrects: boolean Array,  // tiles matched are set to true
//                               // used to change its ccs class
//     scores: int,           // tracking the scores, every click on the
//                            // tile will deduct 1 point, find a match
//                            // will get 10 points.
// }

class Tile extends React.Component {

    render() {
        return (
            <button className= {this.props.correctness ? "tile-correct": this.props.isClicked? "tile2":"tile"}
                    onClick={() => this.props.onClick()}
                    disabled={this.props.isDisabled}>
                {this.props.value}
            </button>
        )
    }
}

class RestartButton extends React.Component {
    render() {
        return (
            <button onClick={() => this.props.onClick()}>
                Restart
            </button>
        )
    }
}

class Game extends React.Component {

    constructor(props) {
        super(props);
        this.channel = props.channel;
        this.channel.join()
                    .receive("ok", this.gotView.bind(this))
                    .receive("error", resp => { console.log("Unable to join", resp); });

        this.state = {
            letters: [],
            lastClicked: null,
            isDisabled: false,
            isClicked: [],
            corrects: [],
            count: 2,
            scores: 0,
        };
    }

    gotView(msg) {
        console.log("Got View", msg);
        this.setState(msg.view);
    }

    handleClick(i) {

        this.channel.push("clickTile", {index: i})
                    .receive("ok", this.gotView.bind(this));
        setTimeout(()=>{
                        this.channel.push("unDisable", {index: i})
                                    .receive("ok", this.gotView.bind(this));},1000);

        // const corrects = this.state.corrects.slice();

        // if(this.state.letters[i] === this.state.letters[this.state.lastClicked] && i !==this.state.lastClicked) {
        //     corrects[i] = true;
        //     corrects[this.state.lastClicked] = true;
        //     this.setState({
        //         letters: this.state.letters,
        //         lastClicked: i,
        //         isDisabled: this.state.isDisabled,
        //         isClicked: this.state.isClicked,
        //         corrects: corrects,
        //         count: 2,
        //         scores: this.state.scores + 10,
        //     });
        //
        // } else {
        //     let clicked = this.state.isClicked.slice();
        //     clicked[i] = true;
        //     this.setState({
        //         letters: this.state.letters,
        //         lastClicked: i,
        //         isDisabled: true,
        //         isClicked: clicked,
        //         correct: this.state.correct,
        //         count: 2,
        //         scores: this.state.scores - 1,
        //     });
        //
        //     setTimeout(()=>{
        //         clicked = Array(16).fill(false);
        //         this.setState({
        //             letters: this.state.letters,
        //             lastClicked: i,
        //             isDisabled: false,
        //             isClicked: clicked,
        //             correct: this.state.correct,
        //             count: 2,
        //             scores: this.state.scores,
        //         });
        //     },1000);
        // }
    }

    handleRestartClick() {

        this.channel.push("restart")
                    .receive("ok", this.gotView.bind(this));

        // let shuffledLetters = this.state.letters;
        // shuffledLetters.sort(()=>{return Math.random()-0.5;});
        // this.setState({
        //     letters: shuffledLetters,
        //     lastClicked: null,
        //     isDisabled: this.state.isDisabled,
        //     isClicked: this.state.isClicked,
        //     corrects: Array(16).fill(false),
        //     scores: 0,
        // });
    }

    renderTile(i) {
        return <Tile value={this.state.letters[i]}
                     onClick={() => this.handleClick(i)}
                     isDisabled={this.state.isDisabled}
                     isClicked={this.state.isClicked[i]}
                     correctness={this.state.corrects[i]}/>;
    }

    renderRestartButton() {
        return <RestartButton
            onClick={() => this.handleRestartClick()}/>;
    }

    render() {
        const scores = 'Scores: ' + this.state.scores;

        return (
            <div className="game-board">
                <div>{scores}</div>
                <div className="tile-table">
                    <table>
                        <tbody>
                        <tr>
                            <td>{this.renderTile(0)}</td>
                            <td>{this.renderTile(1)}</td>
                            <td>{this.renderTile(2)}</td>
                            <td>{this.renderTile(3)}</td>
                        </tr>
                        <tr>

                            <td>{this.renderTile(4)}</td>
                            <td>{this.renderTile(5)}</td>
                            <td>{this.renderTile(6)}</td>
                            <td>{this.renderTile(7)}</td>
                        </tr>
                        <tr>
                            <td>{this.renderTile(8)}</td>
                            <td>{this.renderTile(9)}</td>
                            <td>{this.renderTile(10)}</td>
                            <td> {this.renderTile(11)}</td>
                        </tr>
                        <tr>
                            <td>{this.renderTile(12)}</td>
                            <td> {this.renderTile(13)}</td>
                            <td> {this.renderTile(14)}</td>
                            <td>{this.renderTile(15)}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div>{this.renderRestartButton()}</div>
                <p>Rules: every click on the tile will deduct 1 points from the score.<br/>
                    Find a match will get 10 points.</p>

            </div>
        );
    }
}
