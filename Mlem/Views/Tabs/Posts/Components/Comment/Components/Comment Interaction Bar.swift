//
//  Comment Interaction Bar.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-10.
//

import SwiftUI

import Foundation

/**
 View grouping post interactions--upvote, downvote, save, reply, plus post info
 */
struct CommentInteractionBar: View {
    // environment
    @EnvironmentObject var commentTracker: CommentTracker

    // constants
    let iconPadding: CGFloat = 4
    let iconCorner: CGFloat = 2
    let scoreItemWidth: CGFloat = 12

    // parameters
    let commentView: APICommentView
    let account: SavedAccount

    let displayedScore: Int
    let displayedVote: ScoringOperation
    let displayedSaved: Bool
    
    let upvote: () async -> Void
    let downvote: () async -> Void
    let saveComment: () async -> Void
    let deleteComment: () async -> Void
    let replyToComment: () -> Void

    let height: CGFloat = 24

    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                VoteComplex(vote: displayedVote, score: displayedScore, height: height, upvote: upvote, downvote: downvote)
                    .padding(.trailing, 8)
                
                Spacer()
                
                SaveButton(isSaved: displayedSaved, size: height, accessibilityContext: "comment") {
                    Task(priority: .userInitiated) {
                        await saveComment()
                    }
                }

                ReplyButton(replyCount: commentView.counts.childCount, accessibilityContext: "comment", reply: replyToComment)
                    .foregroundColor(.primary)
            }
            TimestampView(date: commentView.comment.published, spacing: AppConstants.iconToTextSpacing)
        }
        .font(.callout)
    }
    
    func canDeleteComment() -> Bool {
        if commentView.creator.id != account.id {
            return false
        }
        
        if commentView.comment.deleted {
            return false
        }
        
        return true
    }
}
